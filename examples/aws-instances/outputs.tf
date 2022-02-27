
locals {
  fqdns = [ for index, fqdns in module.aws-instances.fqdns.* : fqdns ]
}

output "VM_info" {
  value = [ for index, example in module.aws-instances.instances.* : format("%s%s", "\n    ", join( "\n    ", [
    "================ Machine ${ index } details: ================",
    "AMI        :\t${ example.ami }",
    "PUBLIC_IP  :\t${ example.public_ip }",
    "FQDN       :\t${ local.fqdns[index] }",
    "\n",
    "SSH_CONNECT:\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] }",
    #"SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" ,
    "SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] } 'echo $(hostname): $( grep PRETTY_NAME /etc/os-release | sed -e s/.*=.// -e s/\\\"// ) $(uname -s)/$(uname -r) $(uptime)'",
    "SSH_TEST2  :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] } 'echo $(hostname): CPUs=$(grep -c ^proc /proc/cpuinfo) RAM=$(grep ^MemTotal /proc/meminfo) rootDisk=$(df -h / | grep -v Filesystem)'",
    "\n",
    "CURL_IP    :\tcurl -sL http://${ local.fqdns[index] }:8080" ,
    "CURL_DNS   :\tcurl -sL http://${ example.public_dns }:8080",
    #"SSH_CONNECT:\tssh -i ${ var.key_file } ${ var.user}@${ local.fqdns[index] }",
    #"SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user}@${ local.fqdns[index] } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" ,
    #"\n",
    #"CURL_IP    :\tcurl -sL http://${ local.fqdns[index] }:8080" ,
    #"CURL_DNS   :\tcurl -sL http://${ example.public_dns }:8080",
   ]) )]
}





