
locals {
    num_instances = var.num_groups * var.num_instances_per_group
}

module "aws-lightsail" {
    # https://www.terraform.io/language/modules/sources#selecting-a-revision
    # Pulling from mjbright/terraform-modules:
    # - a sub-directory /modules/instances
    # - a specific commit (ref=sha256)
    #source        = "git::https://github.com/mjbright/terraform-modules.git//modules/aws-lightsail?ref=af0bad34446e2534245c52f527d23d0de4392fdb"
    source         = "../../modules/aws-lightsail"
    #source        = "git::https://github.com/mjbright/terraform-modules.git//modules/aws-lightsail?ref=v0.8"

    #region         = "us-west-2"
    #provider        = "aws"

    # input parameters:
    num_groups         = var.num_groups
    num_instances      = local.num_instances
    instance_type      = var.instance_type

    set_hostnames      = true

    volume_size        = 20
    volume_type        = "gp3"

    ami_family         = var.ami_family

    key_file           = var.key_file
    key_ppk_file       = var.key_ppk_file
    intra_key_file     = var.intra_key_file
    intra_pub_key_file = var.intra_pub_key_file
    user               = var.user

    vpc_ingress_ports  = var.vpc_ingress_ports
    pub_ingress_ports  = var.pub_ingress_ports
    egress_ports       = var.egress_ports

    # User data provisioning: Create student user
    user_data_file     = var.user_data_file

    # Remote-exec provisioner
    provisioner_templatefile = var.provisioner_templatefile

    zip_files = var.zip_files

    # DNS Domain parameters:
    domain  = var.domain
    host    = var.host
    # Optional parameter:
    zone_id = var.zone_id
}

