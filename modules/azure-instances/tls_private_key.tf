
resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# File to save .pem key to:
resource "local_file" "key_local_file" {
  content         = tls_private_key.mykey.private_key_pem
  filename        = var.key_file
  file_permission = 0600
}

data "tls_public_key" "ppk" {
#  depends_on = [ local_file.key_local_file ]
#
#  #private_key_pem = "${file( local_file.key_local_file.filename )}"
  private_key_pem = tls_private_key.mykey.private_key_pem
}

resource "local_file" "key_local_ppk_file" {
  content         = data.tls_public_key.ppk.private_key_pem
  filename        = var.key_ppk_file
  file_permission = 0600
}

