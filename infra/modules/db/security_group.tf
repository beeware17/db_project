resource "aws_security_group" "db_ec2" {
  name        = format(local.resource_name_suffix, "db-ec2-sg")
  description = "Security group for EC2 for db"
  vpc_id      = var.vpc_id
  tags        = merge({ Name : format(local.resource_name_suffix, "db-ec2-sg") }, local.common_tags)
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.db_ec2.id
}