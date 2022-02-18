
module "lookup-ami" {
  #source     = "../../modules/data-aws-ami"
  #source    = "git::https://github.com/mjbright/terraform-modules//modules/data-aws-ami?ref=3814cdf1a03a91a28b468688823387397b261566"
  source    = "git::https://github.com/mjbright/terraform-modules//modules/data-aws-ami?ref=v0.4"

  ami_family = var.ami_family
}

resource "aws_instance" "test" {
  ami                    = module.lookup-ami.ami
  instance_type          = "t2.micro"

  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [ aws_security_group.secgroup-ssh.id ]
}

resource "aws_security_group" "secgroup-ssh" {
  name = "simple security group - ssh"

  # Enable incoming ssh connection:
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"

    # wherever you're from, come on in folks :)
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "tlskey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_id" "key_pair" {
  byte_length = 6
}

resource "aws_key_pair" "generated_key" {
  key_name   = "keypair-${random_id.key_pair.id}"
  public_key = tls_private_key.tlskey.public_key_openssh
}

# File to save .pem key to:
resource "local_file" "key_local_file" {
  content         = tls_private_key.tlskey.private_key_pem
  filename        = var.key_file
  file_permission = 0600
}

