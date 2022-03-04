
#
# TODO:
# - write this to use pub_ingress_port values - use dynamic block?
#
# For info, see:
# - https://citizix.com/how-to-create-aws-lightsail-instance-with-terraform/
# - https://aws.amazon.com/premiumsupport/knowledge-center/lightsail-considerations-for-use/

resource "aws_lightsail_instance_public_ports" "app-server" {
  count             = var.num_instances

  instance_name = aws_lightsail_instance.instances[count.index].name

  port_info {
    protocol  = "tcp"
    from_port = 30000
    to_port   = 32767
  }

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  port_info {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
  }
}


