
locals {

  ssh_config = templatefile("${path.module}/templates/ssh.tpl", {
      node_fqdns = module.aws-lightsail.fqdns,
      node_names = module.aws-lightsail.hosts,
      node_ips   = module.aws-lightsail.public_ip,
      user       = var.user,
      key_file   = var.key_file
  }) 
}

output ssh_config {
    value    = local.ssh_config
}

resource "local_file" "ssh_config" {
    content  = local.ssh_config
    filename = "${path.module}/var/ssh_config"
}

