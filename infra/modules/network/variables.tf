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
# VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

# Subnets
variable "public_subnets_config" {
  description = "Public subnets configuration"
  type        = any
}

variable "private_subnets_config" {
  description = "Private subnets configuration"
  type        = any
}