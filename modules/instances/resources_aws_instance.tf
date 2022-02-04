
resource "aws_instance" "instances" {
  count         = var.num_instances

  instance_type = var.instance_type
  ami           = data.aws_ami.latest_ubuntu_lts_1804.id

  # Don't auto-recreate instance if new ami available:
  lifecycle {
    ignore_changes = [ami]
  }

  #depends_on = [ aws_key_pair.generated_key ]
  depends_on = [ local_file.key_local_file ]

  provisioner "local-exec" {
    # blocks completion of resource
    # command = "touch /tmp/ON_local_TF_HOST; hostname; echo 'This code executes on the local/Terraform host, the remote server IP address is ${self.public_ip}'; while ! curl -L http://${self.public_ip}:8080; do sleep 1; done" 
    command = "touch /tmp/ON_local_TF_HOST; hostname; echo 'This code executes on the local/Terraform host, the remote server IP address is ${self.public_ip}'"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_file)
    #host       = "${var.host}"
    host        = "${self.public_ip}"
  }
   
  provisioner "file" {
    source      = ( var.zip_file == "" ? "/dev/null"  : var.zip_file )
    destination = ( var.zip_file == "" ? "/tmp/.null" : "/tmp/files.zip" )
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
    inline     = ( var.provisioner_templatefile == "" ? [] : [ "touch /tmp/ON_remote_HOST; hostname; echo 'This code executes on the remote resource, (IP address is ${self.public_ip})'; chmod a+x /tmp/remote-exec.sh; sh -x /tmp/remote-exec.sh" ] )
  }

  vpc_security_group_ids = [aws_security_group.secgroup-ssh.id] 

  key_name      = aws_key_pair.generated_key.key_name

  tags = {
    LabName = "modules/provisioners demo"
  }

  ## cloud_init / user_data ---------------------------------------------------------
  # NOTE: cloud-init related output will be recorded in /var/log/syslog
  #       so to see the output (+more) from the below user_data:
  #           grep cloud-init /var/log/syslog

  #user_data = <<-EOF
  #EOF

  #user_data = file("${path.root}/provisioner.sh")

  #user_data = file( var.user_data_filepath )

  user_data = var.user_data_file == "" ? "" : file( var.user_data_file )
}

resource "random_id" "sec_group" {
  byte_length        = 6
}

resource "aws_security_group" "secgroup-ssh" {
  name        = "secgroup-${random_id.sec_group.id}"

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

