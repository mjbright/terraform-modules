
num_groups = 1
num_instances_per_group = 1

user          = "ubuntu"

instance_type = "t2.medium"
ami_family    = "ubuntu_2004"

key_file           = "var/key.pem"
key_ppk_file       = "var/key.ppk"

# Unused for lightsail:
intra_key_file     = ""
intra_pub_key_file = ""

pub_ingress_ports = {
    "ssh":            [22,22], # Enable incoming ssh         connection
    "web"  :      [8080,8080], # Enable incoming web-server  connection
    "flask":      [3000,3000]  # Enable incoming flask(quiz) connection
    "high"  :   [30000,32767], # Enable incoming connections to high-numbered ports
}

vpc_ingress_ports = {
    "all":        [0,0] # All ports/all protocols
}

egress_ports = {
    "ssh":      [22,22], # Enable outgoing ssh   connections ... for git ...
    "http":     [80,80], # Enable outgoing http  connections
    "https":  [443,443]  # Enable outgoing https connections
    "high"  :   [30000,32767], # Enable outgoing connections to high-numbered ports
}

# DNS Domain info:
domain             = "mjbright.click"
host               = "lightsail"
zone_id            = ""

# user data:
user_data_file = "user_data_setup.sh"

# remote_exec/file provisioners:
# Done by user_data_setup.sh:
provisioner_templatefile = ""

zip_files = [ "" ]

