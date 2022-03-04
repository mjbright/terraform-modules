
# NOTE: Resources in this file are created only if
# - number of groups is non-zero
# - number of instances is non-zero (for aws_instance)

module "data_aws_ams" {
  #source = "../data-aws-ami"
  source        = "git::https://github.com/mjbright/terraform-modules.git//modules/data-aws-ami?ref=v0.9.2"

  ami_family = var.ami_family
}

resource "aws_instance" "instances" {
  count         = var.num_instances

  instance_type = var.instance_type

  # Lookup latest image for var.ami_family, else local.default_ami_family:
  ami = ( var.ami == "" ? module.data_aws_ams.ami : var.ami )

  # Don't auto-recreate instance if new ami available:
  lifecycle {
    ignore_changes = [ami]
  }

  depends_on = [ local_file.key_local_file ]

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    #encrypted   = false
    #kms_key_id  = data.aws_kms_key.customer_master_key.arn
  }

  provisioner "local-exec" {
    # blocks completion of resource
    command = "touch /tmp/.local-exec; hostname; echo 'Remote server IP address is ${self.public_ip}'"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_file)
    #host       = "${var.host}"
    host        = "${self.public_ip}"
  }
   
  # Change hostname of each vm (if set_hostnames == true)::
  provisioner "remote-exec" {
    inline     = ( var.set_hostnames ? [ "sudo hostnamectl set-hostname ${local.hostnames[ count.index ]}" ] : [ "true" ]  )
  }

  # May not be needed
  # provisioner "file" {
    # source      = var.intra_key_file
    # destination = "/tmp/intra.pem"
  # }

  # provisioner "file" {
    # source      = var.intra_pub_key_file
    # destination = "/tmp/intra.pub"
  # }

  # Transfer up to 4 zip files if specified in var.zip_files:
  provisioner "file" {
    source      = ( local.zip_files[0] == "" ? "/dev/null"  : local.zip_files[0] )
    destination = ( local.zip_files[0] == "" ? "/tmp/.null" : "/tmp/files1.zip" )
  }

  provisioner "file" {
    source      = ( local.zip_files[1] == "" ? "/dev/null"  : local.zip_files[1] )
    destination = ( local.zip_files[1] == "" ? "/tmp/.null" : "/tmp/files2.zip" )
  }

  provisioner "file" {
    source      = ( local.zip_files[2] == "" ? "/dev/null"  : local.zip_files[2] )
    destination = ( local.zip_files[2] == "" ? "/tmp/.null" : "/tmp/files3.zip" )
  }

  provisioner "file" {
    source      = ( local.zip_files[3] == "" ? "/dev/null"  : local.zip_files[3] )
    destination = ( local.zip_files[3] == "" ? "/tmp/.null" : "/tmp/files4.zip" )
  }

  //var.provisioner_templatefile="templates/webserver.sh.tpl"
  provisioner "file" {
    #source     = "webserver.sh"
    content     = ( var.provisioner_templatefile == "" ? "" : templatefile(var.provisioner_templatefile, {
      web_port  = var.pub_ingress_ports["web"][0]
    })
    )
    destination = "/tmp/remote-exec.sh"
  }

  provisioner "remote-exec" {
    inline     = ( var.provisioner_templatefile == "" ?
      [ "true" ]
         :
      [
        "touch /tmp/.remote-exec",
        "hostname",
        "echo 'Local IP address is ${self.public_ip})'",
        "chmod a+x /tmp/remote-exec.sh",
        "sh -x /tmp/remote-exec.sh"
      ]
    ) 
  }

  vpc_security_group_ids = [aws_security_group.secgroup-ssh[0].id] 

  key_name               = aws_key_pair.generated_key[0].key_name

  tags = merge( var.tags, {
        Module = "aws-instances",
    },
  )

  ## cloud_init / user_data ---------------------------------------------------------
  # NOTE: cloud-init related output will be recorded in /var/log/syslog
  #       so to see the output (+more) from the below user_data:
  #           grep cloud-init /var/log/syslog

  user_data = var.user_data_file == "" ? "" : file( var.user_data_file )
}

resource "random_id" "sec_group" {
  count       = ( var.num_groups > 0 ? 1 : 0 )

  byte_length = 6
}

resource "aws_security_group" "secgroup-ssh" {
  count       = ( var.num_groups > 0 ? 1 : 0 )

  name        = "secgroup-${random_id.sec_group[ count.index] .id}"

  dynamic "ingress" {
    for_each = var.pub_ingress_ports

    content {
      #description = "[pub] Port ${ingress.key}: ${ingress.value[0]}-${ingress.value[1]}"
      description = "[pub] Port ${ingress.key}"
      from_port   = ingress.value[0]
      to_port     = ingress.value[1]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.egress_ports

    content {
      #description = "Port ${egress.key}: ${ingress.value[0]}-${ingress.value[1]}"
      description = "Port ${egress.key}"
      from_port   = egress.value[0]
      to_port     = egress.value[1]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

   ingress {
        # ingress { # Enable ALL protocols/ports between cluster nodes on their internal ips: }
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = var.vpc_cidr
    }

   egress {
        # egress { # Enable ALL protocols/ports between cluster nodes on their internal ips: }
        from_port = 0
        to_port     = 0
        protocol  = "-1"
        cidr_blocks = var.vpc_cidr
    }
}

