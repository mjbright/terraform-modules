
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

# TLS / pem key ----------------------------------------------

resource "tls_private_key" "tlskey" {
  count     = ( var.num_groups > 0 ? 1 : 0 )

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  count      = ( var.num_groups > 0 ? 1 : 0 )

  key_name   = "auto-keypair-${random_id.key_pair[0].id}"
  public_key = tls_private_key.tlskey[ count.index ].public_key_openssh
}

# File to save .pem key to:
resource "local_file" "key_local_file" {
  count           = ( var.num_groups > 0 ? 1 : 0 )

  content         = tls_private_key.tlskey[ count.index ].private_key_pem
  filename        = var.key_file
  file_permission = 0600
}

# Intra-node key_pair ----------------------------------------

resource "aws_key_pair" "intra_key" {
  count      = ( ( var.num_groups > 0 ) && ( var.intra_pub_key_file != "" ) ? 1 : 0 )

  # depends_on = [ var.intra_pub_key_local_file ] # Better than using depends_on in root module

  key_name   = "intra-keypair-${random_id.key_pair[0].id}"
  public_key = file( var.intra_pub_key_file )
}

