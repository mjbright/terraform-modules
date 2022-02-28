
locals {
  fqdns         = [ for index, fqdns in module.aws-lightsail.fqdns.* : fqdns ]
}


output "VM_info" {
  value = [ for index, instance in module.aws-lightsail.instances.* : format("%s%s", "\n    ", join( "\n    ", [
    "================ Machine ${ index } details: ================",
    #"AMI        :\t${ instance.ami }",
    "PUBLIC_IP  :\t${ instance.public_ip_address }",
    "FQDN       :\t${ local.fqdns[index] }",
    "\n",
    "SSH_CONNECT:\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] }",
    #"SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" ,
    "SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] } 'echo $(hostname): $( grep PRETTY_NAME /etc/os-release | sed -e s/.*=.// -e s/\\\"// ) $(uname -s)/$(uname -r) $(uptime)'",
    "SSH_TEST2  :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] } 'echo $(hostname): CPUs=$(grep -c ^proc /proc/cpuinfo) RAM=$(grep ^MemTotal /proc/meminfo) rootDisk=$(df -h / | grep -v Filesystem)'",
    "\n",
    "CURL_IP    :\tcurl -sL http://${ local.fqdns[index] }:8080" ,
    #"CURL_DNS   :\tcurl -sL http://${ instance.public_dns }:8080",
    #"SSH_CONNECT:\tssh -i ${ var.key_file } ${ var.user}@${ local.fqdns[index] }",
    #"SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user}@${ local.fqdns[index] } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" ,
    #"\n",
    #"CURL_IP    :\tcurl -sL http://${ local.fqdns[index] }:8080" ,
    #"CURL_DNS   :\tcurl -sL http://${ instance.public_dns }:8080",
   ]) )]
}

