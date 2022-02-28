
# NOTE: key_pair_name - Created in the Lightsail console (**** cannot use aws_key_pair at this time****)
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance


# NOTE: Resources in this file are created only if
# - number of groups is non-zero
# - number of instances is non-zero (for aws_lightsail_instance)

resource "random_id" "name-prefix" {
  byte_length = 6
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance
resource "aws_lightsail_instance" "instances" {
  count             = var.num_instances

  name              = "ubuntu-${ random_id.name-prefix.id }"
  availability_zone = "us-west-2b"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "small_2_0"

  # NOTE: key_pair_name - Created in the Lightsail console (**** cannot use aws_key_pair at this time****)
  # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance
  # NOT SUPPORTED: key_pair_name     = aws_key_pair.generated_key[0].key_name
  # NOT SUPPORTED: key_pair_name     = aws_key_pair.generated_key[0].id
  #depends_on = [ aws_key_pair.generated_key[0] ]

  key_pair_name     = aws_lightsail_key_pair.gen_key_pair[0].name

  tags = merge( var.tags, {
        Module = "aws-lightsail",
    },
  )

  connection {
    type        = "ssh"
    user        = "ubuntu"
    #private_key = file(var.key_file)
    private_key = aws_lightsail_key_pair.gen_key_pair[ count.index ].private_key
    #host       = "${var.host}"
    host        = "${self.public_ip_address}"
  }

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
        "echo 'Local IP address is ${self.public_ip_address})'",
        "chmod a+x /tmp/remote-exec.sh",
        "sh -x /tmp/remote-exec.sh"
      ]
    ) 
  }

  ## cloud_init / user_data ---------------------------------------------------------
  # NOTE: cloud-init related output will be recorded in /var/log/syslog
  #       so to see the output (+more) from the below user_data:
  #           grep cloud-init /var/log/syslog

  user_data = var.user_data_file == "" ? "" : file( var.user_data_file )
}

