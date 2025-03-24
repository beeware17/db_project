resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.app_instance_type
  subnet_id              = local.app_subnet_id
  iam_instance_profile   = aws_iam_instance_profile.app_ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.app_ec2.id]
  user_data = templatefile("${path.module}/templates/user_data.sh", {
    app_image      = var.app_image,
    port_host      = var.port_host,
    port_container = var.port_container
  })
  user_data_replace_on_change = var.user_data_replace_on_change

  root_block_device {
    tags = {
      "Name" : format(local.resource_name_suffix, "app-root-ebs")
    }
    volume_type           = var.app_root_ebs_config.root_ebs_type
    volume_size           = var.app_root_ebs_config.root_ebs_size
    iops                  = var.app_root_ebs_config.root_ebs_iops
    throughput            = var.app_root_ebs_config.root_ebs_throughput
    encrypted             = true
    delete_on_termination = true
  }
  tags = merge(local.common_tags, { "Name" : format(local.resource_name_suffix, "app-ec2") })
}