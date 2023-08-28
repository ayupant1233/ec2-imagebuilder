resource "aws_iam_role" "ec2_iam_role" {
  name               = var.ec2_iam_role_name
  assume_role_policy = file("files/assumption-policy.json")
  inline_policy {
    name = "ecr_test_instance_inline_policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:GetLifecyclePolicy",
            "ecr:GetLifecyclePolicyPreview",
            "ecr:GetRepositoryPolicyPreview",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken",
            "ecr:GetRegistryCatalogData",
            "ecr:PutImage"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:List*",
            "s3:GetObject",
            "s3:GetBucketPolicy",
            "s3:PutBucketPolicy"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject"
          ],
          "Resource" : [
            "arn:aws:s3:::${var.aws_s3_ami_resources_bucket}/image-builder/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:aws:logs:*:*:log-group:/aws/imagebuilder/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "kms:Decrypt"
          ],
          "Resource" : [
            "*"
          ],
          "Condition" : {
            "ForAnyValue:StringEquals" : {
              "kms:EncryptionContextKeys" : "aws:imagebuilder:arn"
            }
          }
        }
      ]
    })
  }
}

resource "aws_iam_instance_profile" "image_builder_role" {
  name = var.ec2_iam_role_name
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_iam_role" "ecr_test_role" {
  name               = var.ecr_test_role_name
  assume_role_policy = file("files/assumption-policy.json")
  inline_policy {
    name = "ecr_test_inline_policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:GetLifecyclePolicy",
            "ecr:GetLifecyclePolicyPreview",
            "ecr:GetRepositoryPolicyPreview",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken",
            "ecr:GetRegistryCatalogData",
            "ecr:PutImage"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:List*",
            "s3:GetObject",
            "s3:GetBucketPolicy",
            "s3:PutBucketPolicy"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject"
          ],
          "Resource" : [
            "arn:aws:s3:::${var.aws_s3_ami_resources_bucket}/image-builder/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:aws:logs:*:*:log-group:/aws/imagebuilder/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "kms:Decrypt"
          ],
          "Resource" : [
            "*"
          ],
          "Condition" : {
            "ForAnyValue:StringEquals" : {
              "kms:EncryptionContextKeys" : "aws:imagebuilder:arn"
            }
          }
        }
      ]
    })
  }
}

