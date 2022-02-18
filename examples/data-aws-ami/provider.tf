
terraform {
  # Terraform version: not important but let's impose 1.x+ at least
  required_version = "> 1.0"

  # AWS Provider version: not important but let's impose 3.x+ at least
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 3.0"
    }
  }
}

provider "aws" {
  region = var.region

  # Tag all resources:
  default_tags {
    tags = {
      project = "TEST"
      purpose = "Testing data-aws-module"
    }
  }
}

variable "region" {
  description = "the region - export TF_VAR_region=$AWS_DEFAULT_REGION"
  default     = "us-west-1"
}


