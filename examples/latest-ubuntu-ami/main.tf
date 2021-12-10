

provider "aws" {
    region = var.region
}

variable "region" {
    description = "the region - export TF_VAR_region=$AWS_DEFAULT_REGION"
}

variable ami_instance {
    default = "unset"
}

module "latest-ubuntu-ami" {
    source = "./latest-ubuntu-ami"
    region = var.region
}

output ami_instance { value = module.latest-ubuntu-ami.amis_latest_ubuntu_bionic_LTS }

resource "aws_instance" "example" {
    #ami = "ami-0e81aa4c57820bb57"
    ami = module.latest-ubuntu-ami.amis_latest_ubuntu_bionic_LTS

    instance_type = "t2.micro"
    key_name = "terraform-course-keypair"
    vpc_security_group_ids = [aws_security_group.secgroup-user10.id]
}

resource "aws_security_group" "secgroup-user10" {
    name = "simple security group - user10"

    # Enable incoming ssh connection:
    ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


