# Enter values for all of the following if you wish to avoid being prompted on each run.
account_id                   = "<DEPLOYMENT-ACCOUNT-ID>"
aws_region                   = "us-east-2"
vpc_name                     = "ecr-test-pipeline-vpc"
kms_key_alias                = "image-builder-container-key"
ec2_iam_role_name            = "ecr-test-instance-role"
ecr_test_role_name = "ecr-test-pipeline-role"
aws_s3_ami_resources_bucket  = "ecr-test-ami-resources-bucket-0123"
image_name                   = "ecr-test-al2-container-image"
ecr_name                     = "ecr-test-container-repo"
recipe_version               = "1.0.0"
ebs_root_vol_size            = 10
