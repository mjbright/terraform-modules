
variable key_file {
  description = "Path to generated PUB key file (not same as for aws_instance due to aws_lightsail_key_pair differences"
}

variable key_ppk_file {
    default = "key.ppk"
}

variable intra_key_file {
  description = "Path to existing PEM intra cluster key file - to transfer to cluster"
  type = string
}

variable intra_pub_key_file {
  description = "Path to existing public intra cluster key file - for aws_key_pair"
  type = string
}

variable ami {
  description = "Specific AMI to use"
  type        = string
  default     = ""
}

variable ami_family {
  description = "Family of AMIS to search - ubuntu_1804 or ubuntu_2004 - ignored if ami set"
  type        = string
  default     = "ubuntu_1804"
}

variable instance_type {
  description = "EC2 instance type - determines CPU model, # CPUs, RAM"
  type        = string
  default     = "t2.nano"
}

variable user {
  description = "Login user"
  default     = "student"
}

variable num_instances_per_group {
  description = "Number of instances per group"
  default     = "1"
}

variable num_groups {
  description = "Number of groups"
  default     = "1"
}

variable pub_ingress_ports {
  description = "Publix Ingress Ports"
  type = map(list(number))
}

variable vpc_ingress_ports {
  description = "Private Ingress Ports (within this VPC)"
  type = map(list(number))
}

variable egress_ports {
  description = "Egress Ports"
  type = map(list(number))
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

variable zip_files {
  description = "zip files of files to be placed in /tmp, then unpacked from /"
  type        = list(string)
}



