data "aws_iam_policy_document" "trigger_role_policy" {
  statement {
    sid     = "STSRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "trigger_role" {
  name               = "${var.ec2_iam_role_name}-eb-trigger-role"
  assume_role_policy = data.aws_iam_policy_document.trigger_role_policy.json
}

