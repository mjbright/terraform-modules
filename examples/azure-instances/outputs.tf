
locals {
    fqdns    = module.azure-instances.fqdns
    examples = module.azure-instances.instances
}

output "VM_info" {
  value = format("%s%s", "\n    ", join( "\n    ", [
    "================ Machine ${ 0 } details: ================",
    #"AMI        :\t${ local.examples[0].ami }",
    "PUBLIC_IP  :\t${ local.examples[0].public_ip_address }",
    "FQDN       :\t${ local.fqdns[0] }",
    "\n",
    "SSH_CONNECT:\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[0] }",
    #"SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[0] } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" ,
    "SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[0] } 'echo $(hostname): $( grep PRETTY_NAME /etc/os-release | sed -e s/.*=.// -e s/\\\"// ) $(uname -s)/$(uname -r) $(uptime)'",
    "SSH_TEST2  :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[0] } 'echo $(hostname): CPUs=$(grep -c ^proc /proc/cpuinfo) RAM=$(grep ^MemTotal /proc/meminfo) rootDisk=$(df -h / | grep -v Filesystem)'",
    "\n",
    "CURL_IP    :\tcurl -sL http://${ local.fqdns[0] }:8080" ,
    #"CURL_DNS   :\tcurl -sL http://${ local.examples[0].public_dns }:8080",
    #"SSH_CONNECT:\tssh -i ${ var.key_file } ${ var.user}@${ local.fqdns[0] }",
    #"SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user}@${ local.fqdns[0] } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" ,
    #"\n",
    #"CURL_IP    :\tcurl -sL http://${ local.fqdns[0] }:8080" ,
    #"CURL_DNS   :\tcurl -sL http://${ local.examples[0].public_dns }:8080",
   ]) )
}





