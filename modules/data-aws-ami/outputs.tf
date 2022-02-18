
output ami { value = lookup( local.ami_families, var.ami_family, local.default_ami_family ) }

