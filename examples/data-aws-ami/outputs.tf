
output ami_instance { value = module.lookup-ami.ami }

output ssh_test     { value = "ssh -i ${var.key_file} ${var.user}@${aws_instance.test.public_ip} 'echo $(hostname): $(uptime)'" }

