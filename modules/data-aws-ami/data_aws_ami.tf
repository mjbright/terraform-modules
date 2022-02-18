
# data providers are only used (count=1) if:
# - number of groups is non-zero
# - ami_family matches the data.aws_ami instance (rhel8p5, debian9, ubuntu_2004 etc ...)
#
# TODO:
# - isolate as a separate data-aws-ami module
# - refactor code / regroup version by account_number
# - Add more RHEL versions from: https://github.com/KopiCloud/terraform-aws-rhel-ec2-instance/blob/main/rhel-versions.tf

locals {

  default_ami_family       = "ubuntu_2004"

  # For Debian:
  debian_account_number    = "136693071363"
  old_debian_account_number= "379101102735"
  # For Ubuntu:
  canonical_account_number = "099720109477"

  # For RHEL:
  redhat_account_number    = "309956199498"
  # For CentOS 8+:
  fedora_account_number    = "125523088429"
  # For CentOS 6-7:
  centos_account_number    = "679593333241"

  ami_families = {
    "ubuntu_1804":  concat(data.aws_ami.ubuntu_lts_1804.*.id, [""])[0],
    "ubuntu_2004":  concat(data.aws_ami.ubuntu_lts_2004.*.id, [""])[0],

    "rhel8p5":      concat(data.aws_ami.rhel8p5.*.id, [""])[0],

    "centos6":      concat(data.aws_ami.centos6.*.id, [""])[0],
    "centos7":      concat(data.aws_ami.centos7.*.id, [""])[0],
    "centos8":      concat(data.aws_ami.centos8.*.id, [""])[0],
    "centos9":      concat(data.aws_ami.centos9.*.id, [""])[0],

    "debian8":      concat(data.aws_ami.debian8.*.id, [""])[0],
    "debian9":      concat(data.aws_ami.debian9.*.id, [""])[0],
    "debian10":     concat(data.aws_ami.debian10.*.id, [""])[0],
    "debian11":     concat(data.aws_ami.debian11.*.id, [""])[0],

    "amazon2":      concat(data.aws_ami.amazon2.*.id, [""])[0],
  }

}

# Data source to get the latest Debian-8 "Jessie":
# Based on https://wiki.debian.org/Cloud/AmazonEC2Image/Jessie:
#   aws ec2 describe-images --owners 379101102735 --filters "Name=architecture,Values=x86_64" "Name=name,Values=debian-jessie-*" "Name=root-device-type,Values=ebs" "Name=virtualization-type,Values=hvm" --query 'sort_by(Images, &CreationDate)[-1].ImageId'
#   aws ec2 describe-images --owners 379101102735 --filters "Name=architecture,Values=x86_64" "Name=name,Values=debian-jessie-*" "Name=root-device-type,Values=ebs" "Name=virtualization-type,Values=hvm" --query 'sort_by(Images, &CreationDate)[-1]' | jq '.'


data "aws_ami" "debian8" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "debian8" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "debian8" ? 1 : 0 )

  most_recent = true
  owners      = [ local.old_debian_account_number ]

  filter {
    name   = "name"
    values = ["debian-jessie-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get the latest Debian-9 "Stretch":
# Based on https://wiki.debian.org/Cloud/AmazonEC2Image/Stretch:
#   aws ec2 describe-images --owners 379101102735 --filters "Name=architecture,Values=x86_64" "Name=name,Values=debian-stretch-*" "Name=root-device-type,Values=ebs" "Name=virtualization-type,Values=hvm" --query 'sort_by(Images, &CreationDate)[-1].ImageId'
#   aws ec2 describe-images --owners 379101102735 --filters "Name=architecture,Values=x86_64" "Name=name,Values=debian-stretch-*" "Name=root-device-type,Values=ebs" "Name=virtualization-type,Values=hvm" --query 'sort_by(Images, &CreationDate)[-1]' | jq '.'

data "aws_ami" "debian9" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "debian9" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "debian9" ? 1 : 0 )

  most_recent = true
  owners      = [ local.old_debian_account_number ]

  filter {
    name   = "name"
    values = ["debian-stretch-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get the latest Debian-10 "Buster":
# Based on https://wiki.debian.org/Cloud/AmazonEC2Image/Buster:
# Based on https://wiki.debian.org/Amazon/EC2/HowTo/awscli:
#   aws ec2 describe-images --owners 136693071363 --query 'sort_by(Images, &CreationDate)[].[CreationDate,Name,ImageId]' --output table
#   aws ec2 describe-images --region eu-north-1 --owners 136693071363 --query 'sort_by(Images, &CreationDate)[0]'
#   aws ec2 describe-images --owners 136693071363 --filters "Name=architecture,Values=x86_64" "Name=name,Values=debian-10-*" "Name=root-device-type,Values=ebs" "Name=virtualization-type,Values=hvm" --query 'sort_by(Images, &CreationDate)[-1]' | jq '.'
#   

data "aws_ami" "debian10" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "debian10" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "debian10" ? 1 : 0 )

  most_recent = true
  owners      = [ local.debian_account_number ]

  filter {
    name   = "name"
    values = ["debian-10-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get the latest Debian-11 "Bullseye":

data "aws_ami" "debian11" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "debian11" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "debian11" ? 1 : 0 )

  most_recent = true
  owners      = [ local.debian_account_number ]

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get the latest Ubuntu 20.04 LTS:

data "aws_ami" "ubuntu_lts_2004" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "ubuntu_2004" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "ubuntu_2004" ? 1 : 0 )

  owners      = [ local.canonical_account_number ]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get the latest Ubuntu 18.04 LTS:

data "aws_ami" "ubuntu_lts_1804" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "ubuntu_1804" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "ubuntu_1804" ? 1 : 0 )
  #count       = ( var.num_groups > 0 ? 1 : var. ami_family = "ubuntu_1804" )
  #count       = 1
  #count       = ( var.num_groups > 0 ? 1 : 0 )

  owners      = [ local.canonical_account_number ]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get the latest RHEL 8.5:

data "aws_ami" "rhel8p5" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "rhel8p5" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "rhel8p5" ? 1 : 0 )

  owners      = [ local.redhat_account_number    ]
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8.5*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get the latest CentOS 9:

data "aws_ami" "centos9" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "centos9" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "centos9" ? 1 : 0 )

  owners      = [ local.fedora_account_number    ]
  most_recent = true

  filter {
      name   = "name"
      values = ["CentOS Stream 9*"]
  }
  filter {
      name   = "architecture"
      values = ["x86_64"]
  }
  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}

# Data source to get the latest CentOS 8:

data "aws_ami" "centos8" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "centos8" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "centos8" ? 1 : 0 )

  owners      = [ local.fedora_account_number    ]
  most_recent = true

  filter {
      name   = "name"
      values = ["CentOS 8*"]
  }
  filter {
      name   = "architecture"
      values = ["x86_64"]
  }
  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}

# Data source to get the latest CentOS 7:

data "aws_ami" "centos7" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "centos7" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "centos7" ? 1 : 0 )

  owners      = [ local.centos_account_number    ]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Data source to get the latest CentOS 6:

data "aws_ami" "centos6" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "centos6" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "centos6" ? 1 : 0 )

  owners      = [ local.centos_account_number ]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 6 x86_64 HVM EBS *"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Data source to get the latest Amazon Linux:

data "aws_ami" "amazon2" {
  #count       = ( alltrue( [ var.num_groups > 0, var.ami_family == "amazon2" ] ) ? 1 : 0 )
  count       = ( var.ami_family == "amazon2" ? 1 : 0 )

  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

