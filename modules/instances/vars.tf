
variable ami_account {
  description = "AWS account to search for images"
  type        = string
}

variable num_instances {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable key_file {
  description = "Path to generated PEM key file"
  type = string
}

variable user {
  description = "Login user"
  type        = string
  default     = "ubuntu"
}

variable ingress_ports {
  description = "Ingress Ports"
  type        = map(number)
}

variable egress_ports {
  description = "Egress Ports"
  type        = map(number)
}

variable domain {
  description = "DNS domain name of form 'mycompany.com' without trailing '.'"
  type        = string
}

variable host {
  description = "DNS host name to use within the domain"
  type        = string
}

variable zone_id {
  description = "DNS zone_id: optional parameter"
  type        = string
  default     = ""
}

variable user_data_filepath {
  description = "Optional path to user_data for VM provisioning"
  type        = string
}

variable provisioner_templatefile {
  description = "Optional path to provisioner_templatefile for file cp, then execution"
  type        = string
}
