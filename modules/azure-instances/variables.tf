
variable location {
  description = "The Azure Region to use"
}

variable vm_size {
  # See https://azure.microsoft.com/en-us/pricing/vm-selector/
  description = "The Azure Region to use"
}

variable image_publisher {
  description ="Publisher of VM image to use, e.g. Canonical for generic Ubuntu images"
}

variable image_offer {
  description ="Which class of image to use, e.g. UbuntuServer"
}

variable image_sku {
  description ="Image SKU to use"
}

variable image_version {
  description ="Which version to choose, e.g. 'latest' build"
}

variable dns_name {
  description = "Prefix for Azure provided fqdn"
}

variable net_cidr {
  description = "CIDR range to use for virtual network"
}

variable subnet_cidr {
  description = "CIDR range to use for internal subnet within the virtual network"
}

variable admin_user {
  description = "Default (admin) login user"
}

#variable admin_ssh_pub_key {
#  description = "Public key to use to ssh as (admin) user"
#}

variable key_file {
    default = "key.pem"
}

variable key_ppk_file {
    default = "key.ppk"
}

variable prefix {
  description = "The prefix used for all resource names"
}

variable provisioner_templatefile {
  description = "optional: template file for script to run under remote-exec"
  default     = "/dev/null"
}

variable pub_ingress_ports {
  description = "Public Ingress Ports"
  type        = map(list(number))
}

