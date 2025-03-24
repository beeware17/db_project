## TODO: Add provider and remote backend.
terraform {
  backend "s3" {
    bucket  = "825765418393-app-tfstate"
    key     = "tfstate"
    region  = "eu-north-1"
    profile = "demo"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "demo"
}