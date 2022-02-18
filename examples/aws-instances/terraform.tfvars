
key_file = "key.pem"

pub_ingress_ports = {
    "ssh":            [22,22], # Enable incoming ssh         connection
    "web"  :      [8080,8080], # Enable incoming web-server  connection
    "flask":      [3000,3000]  # Enable incoming flask(quiz) connection
    "high"  :   [30000,32767], # Enable incoming connections to high-numbered ports
}

vpc_ingress_ports = {
    "":             [0,0]
}

egress_ports = {
    "http":    [80,80], # Enable outgoing http  connections
    "https": [443,443]  # Enable outgoing https connections
}

# DNS Domain info:
#domain             = "YOUR-DOMAIN.NET"
domain             = "mjbright.click"
host               = "INSTANCE-NAME"
zone_id            = ""

# user data:
user_data_file = "user_data_setup.sh"

# remote_exec/file provisioners:
provisioner_templatefile = "/dev/null"

files_to_transfer = [
  "/etc/hosts", "/etc/lsb-release",
]

zip_files = [ "files/files.zip" ]

intra_pub_key_file = ""
intra_key_file = ""

ami_family = "ubuntu_2004"
#ami = "ami-08fa7c8891945eae4"

