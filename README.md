# terraform-modules

Some sample Terraform modules
- latest-ubuntu-ami: simple example wrapper around the aws_ami data source - for Ubuntu LTS images
- data-aws-ami:      look up the latest ami in current region for a particular family (centos8, ubuntu_2004, ...)
- aws-instances:     create EC2 instances - includes several features: ami lookup, provisioners, ingress/egress ports, Route53 DNS
- azure-instances:   create Azure linuxVM instances (less elaborate than aws-instances) 
- aws-lightsail:     create AWS Lightsail instances (less elaborate than aws-instances) 

Modules are under modules/

Example usage are under examples/
