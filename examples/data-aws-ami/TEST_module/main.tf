
provider aws { }

module "ami-ubuntu1804" {
  #source     = "../../../modules/data-aws-ami"
  #source    = "git::https://github.com/mjbright/terraform-modules//modules/data-aws-ami?ref=3814cdf1a03a91a28b468688823387397b261566"
  source    = "git::https://github.com/mjbright/terraform-modules//modules/data-aws-ami?ref=v0.4"

  ami_family = "ubuntu_1804"
}

module "ami-ubuntu2004" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "ubuntu_2004"
}

module "ami-rhel8p5" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "rhel8p5"
}

module "ami-centos6" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "centos6"
}

module "ami-centos7" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "centos7"
}

module "ami-centos8" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "centos8"
}

module "ami-centos9" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "centos9"
}

module "ami-debian8" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "debian8"
}

module "ami-debian9" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "debian9"
}

module "ami-debian10" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "debian10"
}

module "ami-debian11" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "debian11"
}

module "ami-amazon2" {
  source     = "../../../modules/data-aws-ami"

  ami_family = "amazon2"
}
