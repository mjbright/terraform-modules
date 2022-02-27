
locals {
  fqdn = "${var.dns_name}.${var.location}.cloudapp.azure.com"

  #ssh = "ssh -i ${ var.key_file } ${ var.admin_user }@${ azurerm_linux_virtual_machine.main.public_ip_addresses[0] }"
  #ssh = "ssh -i ${ var.key_file } ${ var.admin_user }@${ azurerm_linux_virtual_machine.main.public_ip_address }"
  ssh = "ssh -i ${ var.key_file } ${ var.admin_user }@${ local.fqdn }"
}

output instances { value = [ azurerm_linux_virtual_machine.main ] }
output fqdns     { value = [ local.fqdn ] }

output public_ip {
  value = azurerm_linux_virtual_machine.main.public_ip_address
}

output public_ips {
  value = azurerm_linux_virtual_machine.main.public_ip_addresses
}

output connect {
  value = local.ssh
}

output vm_info {
  #value = "${local.ssh} 'echo $(hostname): $(uname -s)/$(uname -r) $(uptime)'"
  value = "${local.ssh} 'echo $(hostname): $( grep PRETTY_NAME /etc/os-release | sed -e s/.*=.// -e s/\"// ) $(uname -s)/$(uname -r) $(uptime)'"
}

output vm_info2 {
  value = "${local.ssh} 'echo $(hostname): CPUs=$(grep -c ^proc /proc/cpuinfo) RAM=$(grep ^MemTotal /proc/meminfo) rootDisk=$(df -h / | grep -v Filesystem)'"
}

output ssh_rsa_pub_key { value = tls_private_key.mykey.public_key_openssh }

output ssh_pem_key     {
  value = tls_private_key.mykey.private_key_pem
  sensitive = true
}

output ppk              {
  value = data.tls_public_key.ppk.private_key_pem
  sensitive = true
}

