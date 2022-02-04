
variable ami_account {
  description = "AWS account to search for images"
  type        = string
}

variable instance_type {
  description = "EC2 instance type - determines CPU model, # CPUs, RAM"
  type        = string
  default     = "t2.nano"
}

variable num_instances {
  description = "Number of EC2 instances to create = num_groups * num_instances_per_group"
  type        = number
  default     = 1
}

variable num_groups {
  description = "Number of groups of instances"
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

variable pub_ingress_ports {
  description = "Public Ingress Ports"
  type        = map(list(number))
}

variable vpc_ingress_ports {
  description = "Private Ingress Ports [within VPC]"
  type        = map(list(number))
}

variable vpc_cidr {
  description = "Private CIDR RANGE [within VPC]"
  type        = list(string)
  default     = ["172.31.0.0/20"]
}

variable egress_ports {
  description = "Egress Ports"
  type        = map(list(number))
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

variable user_data_file {
  description = "Optional path to user_data for VM provisioning"
  type        = string
}

variable provisioner_templatefile {
  description = "Optional path to provisioner_templatefile for file cp, then execution"
  type        = string
}

variable zip_file {
  type        = string
}
