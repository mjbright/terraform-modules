
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  #region = "us-west-1"

  # default_tags: accessible as <resource>.tags_all (merged with resource specific tags)
  default_tags {
    tags = {
      Environment = "Bastion Setup"
      Owner       = "@mjbC"
      Module      = "https://github.com/mjbright/terraform-modules/tree/master/modules/aws-lightsail"
    }
  }
}

