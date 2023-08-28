resource "aws_imagebuilder_image" "al2_container_latest" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.ecr-test.arn
  container_recipe_arn             = aws_imagebuilder_container_recipe.container_image.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.ecr-test.arn

  tags = {
    Name    = var.image_name
  }

  depends_on = [
    aws_iam_role.ec2_iam_role,
    aws_iam_role.ecr_test_role,
    aws_security_group.image_builder_sg,
    aws_s3_bucket_object.component_files,
    aws_imagebuilder_distribution_configuration.ecr-test,
    aws_kms_key.ecr-test
  ]
}
