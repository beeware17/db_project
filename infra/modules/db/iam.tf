data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid = "AllowAssumeRoleForEC2"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "db" {
  statement {
    sid       = "AllowS3FullAccess"
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
  statement {
    sid       = "AllowVolumeOperation"
    effect    = "Allow"
    actions = ["ec2:AttachVolume", "ec2:DetachVolume"]
    resources = [aws_ebs_volume.db_ext.arn, aws_instance.db.arn]

  }
}

resource "aws_iam_policy" "db_customer_managed" {
  name   = format(local.resource_name_suffix, "db-ec2-policy")
  policy = data.aws_iam_policy_document.db.json
}

resource "aws_iam_role_policy_attachment" "db_policy_attachment" {
  role       = aws_iam_role.db.name
  policy_arn = aws_iam_policy.db_customer_managed.arn
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  role       = aws_iam_role.db.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "db" {
  name                  = format(local.resource_name_suffix, "db-ec2-instance-role")
  description           = "IAM role for DB"
  assume_role_policy    = data.aws_iam_policy_document.ec2_assume_role.json
  force_detach_policies = true
  tags = merge({
    "Name" : format(local.resource_name_suffix, "db-ec2-instance-role")
  }, local.common_tags)
}

resource "aws_iam_instance_profile" "db_ec2_instance_profile" {
  name = format(local.resource_name_suffix, "db-v2-ec2-instance-profile")
  role = aws_iam_role.db.name
}