
module "instances" {
    # https://www.terraform.io/language/modules/sources#selecting-a-revision
    # Pulling from mjbright/terraform-modules:
    # - a sub-directory /modules/instances
    # - a specific commit (ref=sha256)
    #source        = "git::https://github.com/mjbright/terraform-modules.git//modules/aws-instances?ref=af0bad34446e2534245c52f527d23d0de4392fdb"
    source        = "../../modules/aws-instances"
    #source        = "git::https://github.com/mjbright/terraform-modules.git//modules/aws-instances?ref=v0.3"

    # input parameters:
    num_instances     = var.nodes

    # ami: takes precedence over ami_family:
    ami               = var.ami 
    ami_family        = var.ami_family

    #key_pair         = ""
    key_file          = var.key_file
    intra_pub_key_file = ""
    intra_key_file    = ""

    user              = var.user
    pub_ingress_ports = var.pub_ingress_ports
    vpc_ingress_ports = var.vpc_ingress_ports
    egress_ports      = var.egress_ports

    # User data provisioning:
    user_data_file    = var.user_data_file
    zip_files         = var.zip_files

    # Remote-exec provisioner
    provisioner_templatefile = var.provisioner_templatefile

    # DNS Domain parameters:
    domain  = var.domain
    host    = var.host
    # Optional parameter:
    zone_id = var.zone_id
}


