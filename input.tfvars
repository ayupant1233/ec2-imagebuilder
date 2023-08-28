# Enter values for all of the following if you wish to avoid being prompted on each run.
account_id                   = "643306558745"
aws_region                   = "us-west-1"
vpc_name                     = "ecr-test-1-pipeline-vpc"
kms_key_alias                = "image-builder-container-key"
ec2_iam_role_name            = "ecr-test-1-instance-role"
ecr_test_role_name = "ecr-test-1-pipeline-role"
aws_s3_ami_resources_bucket  = "ecr-test-1-ami-resources-bucket-0123"
image_name                   = "ecr-test-1-al2-container-image"
ecr_name                     = "ecr-test-1-container-repo"
recipe_version               = "1.0.0"
ebs_root_vol_size            = 30
