resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.db_instance_type
  subnet_id              = local.db_subnet_id
  iam_instance_profile   = aws_iam_instance_profile.db_ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.db_ec2.id]
  user_data = templatefile("${path.module}/templates/user_data.sh", {
    ebs_volume_id       =  aws_ebs_volume.db_ext.id
  })
  user_data_replace_on_change = var.user_data_replace_on_change

  root_block_device {
    tags = {
      "Name" : format(local.resource_name_suffix, "db-root-ebs")
    }
    volume_type           = var.db_root_ebs_config.root_ebs_type
    volume_size           = var.db_root_ebs_config.root_ebs_size
    iops                  = var.db_root_ebs_config.root_ebs_iops
    throughput            = var.db_root_ebs_config.root_ebs_throughput
    encrypted             = true
    delete_on_termination = true
  }
  tags = merge(local.common_tags, { "Name" : format(local.resource_name_suffix, "db-ec2") })
  
}

