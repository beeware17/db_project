resource "aws_ebs_volume" "db_ext" {
  availability_zone = data.aws_subnet.db_subnet.availability_zone
  size              = var.db_ext_ebs_size
  type              = var.db_ext_ebs_type
  encrypted         = true

  tags = merge(local.common_tags, { "Name" : format(local.resource_name_suffix, "db-ext-ec2") })
}