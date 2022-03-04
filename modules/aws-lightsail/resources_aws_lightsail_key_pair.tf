
# NOTE: key_pair_name - Created in the Lightsail console (**** cannot use aws_key_pair at this time****)
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance

# NOTE: Resources in this file are created only if
# - number of groups is non-zero

# Automatically create:
# - a TLS private key
# - a corresponding aws_key_pair
# - a local_file with the private key contents (.pem)
#
# Automatically create:
# - a aws_key_pair for the provided intra-cluster pem key
# 

resource "random_id" "key_pair" {
  count       = ( var.num_groups > 0 ? 1 : 0 )

  byte_length = 6
}

resource "aws_lightsail_key_pair" "gen_key_pair" {
  count      = ( var.num_groups > 0 ? 1 : 0 )

  name   = "auto-ls-keypair-${random_id.key_pair[0].id}"
}

# File to save .pem key to:
resource "local_file" "key_local_file" {
  count           = ( var.num_groups > 0 ? 1 : 0 )

  #content         = aws_lightsail_key_pair.gen_key_pair[ count.index ].public_key
  content         = aws_lightsail_key_pair.gen_key_pair[ count.index ].private_key
  filename        = var.key_file
  file_permission = 0600
}

data "tls_public_key" "ppk" {
  count           = ( var.num_groups > 0 ? 1 : 0 )

#  depends_on = [ local_file.key_local_ppk_file ]
#
  private_key_pem = aws_lightsail_key_pair.gen_key_pair[ count.index ].private_key
}

# File to save .ppk key to:
resource "local_file" "key_local_ppk_file" {
  count           = ( var.num_groups > 0 ? 1 : 0 )

  content         = data.tls_public_key.ppk[ count.index ].private_key_pem
  filename        = var.key_ppk_file
  file_permission = 0600
}


