
variable key_file {
  description = "Path to generated PEM key file"
}

variable user {
  description = "Login user"
  default     = "ubuntu"
 
}

variable nodes {
  description = "Number of VMs"
  default     = 1
}

locals {
  canonical_account_number = "099720109477"
}

variable pub_ingress_ports {
  description = "Public Ingress Ports"
  type        = map(list(number))
}

variable vpc_ingress_ports {
  description = "VPC Ingress Ports"
  type        = map(list(number))
}

variable egress_ports {
  description = "Egress Ports"
  type        = map(list(number))
}

variable host {
  description = "DNS host name"
  type        = string
}

variable domain {
  description = "DNS domain name"
  type        = string
}

variable zone_id {
  description = "DNS zone_id"
  type        = string
}

variable user_data_file {
  description = "Optional path to user_data for VM provisioning"
  type        = string
}

variable provisioner_templatefile {
  description = "Optional path to provisioner_templatefile for file cp, then execution"
  type        = string
}

variable files_to_transfer {
  type        = list(string)
}

variable zip_file {
  type        = string
  default     = "/dev/null"
}
