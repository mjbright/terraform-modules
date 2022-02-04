
output "ami"          { value = aws_instance.instances.*.ami }

output "public_ip"    { value = aws_instance.instances.*.public_ip }

output "public_dns"   { value = aws_instance.instances.*.public_dns }

output "key_pair"     { value = aws_key_pair.generated_key.key_name }

output "instances"    { value = aws_instance.instances.* }

output "fqdn"         { value = aws_route53_record.instance_name.*.fqdn }


