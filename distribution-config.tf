resource "aws_ecr_repository" "ecr_test_repo" {
  name                 = var.ecr_name
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr-test.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

resource "aws_imagebuilder_distribution_configuration" "ecr-test" {
  # Modify ecr-test name if desired
  name = "local-distribution"

  distribution {
    ami_distribution_configuration {

      ami_tags = {
        Name = "${var.image_name}-{{ imagebuilder:buildDate }}"
      }

      name = "${var.image_name}-{{ imagebuilder:buildDate }}"

      launch_permission {
        user_ids = [var.account_id]
      }

      kms_key_id = aws_kms_key.ecr-test.arn
    }
    region = var.aws_region
  }
}
