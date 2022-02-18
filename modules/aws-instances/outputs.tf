
output "ami"              { value = aws_instance.instances.*.ami }

output "public_ip"        { value = aws_instance.instances.*.public_ip }

output "public_dns"       { value = aws_instance.instances.*.public_dns }

output "key_pair"         { value = ( var.num_groups > 0 ?  aws_key_pair.generated_key[0].key_name : "") }

output "instances"        { value = aws_instance.instances.* }

output "fqdns"            { value = aws_route53_record.instance_name.*.fqdn }

output "hosts"            { value = local.hostnames }

output "global_etc_hosts" { value = local.global_etc_hosts_lines }

