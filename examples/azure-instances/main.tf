
module "azure-instances" {
    # https://www.terraform.io/language/modules/sources#selecting-a-revision
    # Pulling from mjbright/terraform-modules:
    # - a sub-directory /modules/instances
    # - a specific commit (ref=sha256)
    #source        = "git::https://github.com/mjbright/terraform-modules.git//modules/aws-instances?ref=af0bad34446e2534245c52f527d23d0de4392fdb"
    source        = "../../modules/azure-instances"
    #source        = "git::https://github.com/mjbright/terraform-modules.git//modules/azure-instances?ref=v0.8"

    # input parameters:
    # num_instances     = var.nodes

    location            = var.region

    # ami: takes precedence over ami_family:
    # ami               = var.ami 
    # ami_family        = var.ami_family

    #key_pair         = ""
    key_file          = var.key_file
    key_ppk_file      = var.key_ppk_file
    # intra_pub_key_file = ""
    # intra_key_file    = ""

    net_cidr            = var.net_cidr
    subnet_cidr         = var.subnet_cidr

    # user              = var.user
    admin_user          = var.user
    pub_ingress_ports = var.pub_ingress_ports
    # pub_ingress_ports = var.pub_ingress_ports
    # vpc_ingress_ports = var.vpc_ingress_ports
    # egress_ports      = var.egress_ports

    # User data provisioning:
    # user_data_file    = var.user_data_file
    # zip_files         = var.zip_files

    # Remote-exec provisioner
    provisioner_templatefile = var.provisioner_templatefile

    dns_name          = var.host

    prefix            = var.prefix

    vm_size           = var.vm_size

    image_publisher   = var.image_publisher
    image_offer       = var.image_offer
    image_sku         = var.image_sku
    image_version     = var.image_version
}

