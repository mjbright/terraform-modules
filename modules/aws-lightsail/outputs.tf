
# output "ami"              { value = aws_lightsail_instance.instances.*.ami }

output "public_ip"        { value = aws_lightsail_instance.instances.*.public_ip_address }

#output "public_dns"       { value = aws_lightsail_instance.instances.*.public_dns }

output "key_pair"         { value = ( var.num_groups > 0 ? aws_lightsail_key_pair.gen_key_pair[0].public_key : "") }

output "instances"        { value = aws_lightsail_instance.instances.* }

output "fqdns"            { value = aws_route53_record.instance_name.*.fqdn }

output "hosts"            { value = local.hostnames }

output "global_etc_hosts" { value = local.global_etc_hosts_lines }

