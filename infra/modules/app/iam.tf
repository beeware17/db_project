data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid = "AllowAssumeRoleForECS"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "app" {
  statement {
    sid       = "AllowS3FullAccess"
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "app_customer_managed" {
  name   = format(local.resource_name_suffix, "app-ec2-policy")
  policy = data.aws_iam_policy_document.app.json
}

resource "aws_iam_role_policy_attachment" "app_policy_attachment" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.app_customer_managed.arn
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "app" {
  name                  = format(local.resource_name_suffix, "app-ec2-instance-role")
  description           = "IAM role for App"
  assume_role_policy    = data.aws_iam_policy_document.ec2_assume_role.json
  force_detach_policies = true
  tags = merge({
    "Name" : format(local.resource_name_suffix, "app-ec2-instance-role")
  }, local.common_tags)
}

resource "aws_iam_instance_profile" "app_ec2_instance_profile" {
  name = format(local.resource_name_suffix, "app-v2-ec2-instance-profile")
  role = aws_iam_role.app.name
}