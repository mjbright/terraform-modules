# terraform-modules

Some sample Terraform modules, which serve as examples in various training scenarios

Modules are under modules/

Example usage are under examples/

# AWS
- aws-instances:     create EC2 instances - includes several features: ami lookup, provisioners, ingress/egress ports, Route53 DNS
- aws-lightsail:     create AWS Lightsail instances (less elaborate than aws-instances) 
- data-aws-ami:      look up the latest ami in current region for a particular family (centos8, ubuntu_2004, ...)
- latest-ubuntu-ami: simple example wrapper around the aws_ami data source - for Ubuntu LTS images

# Azure
- azure-instances:   create Azure linuxVM instances (less elaborate than aws-instances) 
- kumarvna-azurerm-virtual-machine: Work in progress
- kumarvna-azurerm-virtual-machine.RG: Work in progress

# Docker
- docker-3-tier: simplistic module creating a load-balancer and N backend servers
- be-container-servers: module to create N backend servers
  - can be used standalone
- fe-container-lb:      module to create a load-balancer for a set of servers
  - intended to be used alongside be-container-servers module



