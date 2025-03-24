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

# VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
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

variable "app_image" {
  description = "Docker image"
}

