# Creates all networking infrastructure needed to deploy container image in Private Subnet with a NAT Gateway
# Amazon Linux Container images currently need internet access in order to bootstrap by AWSTOE
# VPC Endpoints cannot be used
# This solution can be modified to utilize only VPC Endpoints when the bootstrap process is updated
resource "aws_vpc" "ecr_test" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_flow_log" "ecr_test_flow" {
  depends_on = [
    aws_s3_bucket.s3_pipeline_logging_bucket_logs
  ]
  log_destination      = aws_s3_bucket.s3_pipeline_logging_bucket_logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.ecr_test.id
}

# Map public IP on launch because we are creating an internet gateway
resource "aws_subnet" "ecr_test_public" {
  depends_on = [
    aws_vpc.ecr_test
  ]

  vpc_id                  = aws_vpc.ecr_test.id
  cidr_block              = "192.168.0.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_subnet" "ecr_test_private" {
  depends_on = [
    aws_vpc.ecr_test,
    aws_subnet.ecr_test_public
  ]

  vpc_id            = aws_vpc.ecr_test.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_default_security_group" "ecr_test_vpc_default" {
  vpc_id = aws_vpc.ecr_test.id
}

resource "aws_internet_gateway" "ecr_test_igw" {
  depends_on = [
    aws_vpc.ecr_test,
    aws_subnet.ecr_test_public,
    aws_subnet.ecr_test_private
  ]

  vpc_id = aws_vpc.ecr_test.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}
resource "aws_route_table" "ecr_test_public_rt" {
  depends_on = [
    aws_vpc.ecr_test,
    aws_internet_gateway.ecr_test_igw
  ]
  vpc_id = aws_vpc.ecr_test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecr_test_igw.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}
resource "aws_route_table_association" "ecr_test_rt_assoc" {
  depends_on = [
    aws_vpc.ecr_test,
    aws_subnet.ecr_test_public,
    aws_subnet.ecr_test_private,
    aws_route_table.ecr_test_public_rt
  ]
  subnet_id      = aws_subnet.ecr_test_public.id
  route_table_id = aws_route_table.ecr_test_public_rt.id
}
resource "aws_eip" "nat_gateway_eip" {
  depends_on = [
    aws_route_table_association.ecr_test_rt_assoc
  ]
  vpc = true
}
resource "aws_nat_gateway" "ecr_test_nat_gateway" {
  depends_on = [
    aws_eip.nat_gateway_eip
  ]
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.ecr_test_public.id
  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
}
resource "aws_route_table" "ecr_test_nat_gateway_rt" {
  depends_on = [
    aws_nat_gateway.ecr_test_nat_gateway
  ]
  vpc_id = aws_vpc.ecr_test.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecr_test_nat_gateway.id
  }
  tags = {
    Name = "${var.vpc_name}-nat-gateway-rt"
  }
}
resource "aws_route_table_association" "ecr_test_nat_gw_rt_assoc" {
  depends_on = [
    aws_route_table.ecr_test_nat_gateway_rt
  ]
  subnet_id      = aws_subnet.ecr_test_private.id
  route_table_id = aws_route_table.ecr_test_nat_gateway_rt.id
}
