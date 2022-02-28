
key_file     = "key.pem"
key_ppk_file = "key.ppk"

region   = "westus"

pub_ingress_ports = {
    "ssh":            [22,22], # Enable incoming ssh         connection
    "web"  :      [8080,8080], # Enable incoming web-server  connection
    "flask":      [3000,3000], # Enable incoming flask(quiz) connection
    "high"  :   [30000,32767], # Enable incoming connections to high-numbered ports
}

vpc_ingress_ports = {
    "":             [0,0]
}

egress_ports = {
    "http":    [80,80], # Enable outgoing http  connections
    "https": [443,443], # Enable outgoing https connections
}

host        = "instance-name"

net_cidr    = "192.168.0.0/20"
subnet_cidr = "192.168.0.0/24"

# user data:
user_data_file = "user_data_setup.sh"

# remote_exec/file provisioners:
provisioner_templatefile = "/dev/null"

files_to_transfer = [
  "/etc/hosts", "/etc/lsb-release",
]

# zip_files = [ "files/files.zip" ]

intra_pub_key_file = ""
intra_key_file = ""

# ami_family = "ubuntu_2004"

# -- Choice of VM size: ---------------------------------------------------------------
# See: https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable
#vm_size        = "Standard_D2s_v3"
vm_size        = "Standard_B1ms"

# -- Choice of VM image:---------------------------------------------------------------
# Ubuntu 18.04 LTS:
#image_publisher = "Canonical"
#image_offer     = "UbuntuServer"
#image_sku       = "18.04-LTS"
#image_version   = "latest"

# Ubuntu 20.04 LTS:
# See: https://github.com/Azure/azure-cli/issues/13320#issuecomment-649867249
# OLD - Canonical:0001-com-ubuntu-server-focal:20_04-lts:20.04.202006100
# az vm image list -p canonical -o table --all | grep 20_04-lts | grep -v gen2
# ==> 0001-com-ubuntu-server-focal                  Canonical    20_04-lts                     Canonical:0001-com-ubuntu-server-focal:20_04-lts:20.04.202201310 20.04.202201310
# ==> Canonical:0001-com-ubuntu-server-focal:20_04-lts:20.04.202201310

image_publisher = "Canonical"
image_offer     = "0001-com-ubuntu-server-focal"
image_sku       = "20_04-lts"
image_version   = "latest"
#image_version   = "20.04.202201310"

prefix = "aztest"

