### Common variables
variable "aws_region" {
  description = "AWS region name for terraform provider"
  type        = string
}

variable "environment" {
  description = "Environment name for naming"
  type        = string

  validation {
    condition     = var.environment == "development" || var.environment == "production"
    error_message = "Environment must be either development or production"
  }
}

### Network
variable "vpc_id" {
  description = "VPC ID for placing EC2"
  type        = string
}

variable "private_subnets_ids" {
  description = "Private subnets ID list"
  type        = list(any)
}

### EC2
variable "ami_name_filter" {
  description = "Filter for data source"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240927"
}

variable "db_instance_type" {
  description = "EC2 instance type for db"
  type        = string
  default     = "t2.micro"
}

variable "db_root_ebs_config" {
  description = "DB root EBS disk config"
  type        = any
  default = {
    root_ebs_type       = "gp3",
    root_ebs_size       = 8,
    root_ebs_iops       = 3000,
    root_ebs_throughput = 125
  }
}

variable "user_data_replace_on_change" {
  description = "Safety measure"
  default     = true
}

variable "db_ext_ebs_az_letter" {
  description = "AZ letter for db external EBS"
  type        = string
  default     = "a"
}

variable "db_ext_ebs_size" {
  description = "Size of external EBS for db"
  type        = number
  default     = 8
}

variable "db_ext_ebs_type" {
  description = "Type of external EBS for db"
  type        = string
  default     = "gp3"
}
