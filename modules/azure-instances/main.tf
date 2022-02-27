
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-pubip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = var.dns_name
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = [ var.net_cidr ]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "private-subnet" {
  name                 = "private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [ var.subnet_cidr ]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.private-subnet.id
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size

  # Seem to be ignored:
  depends_on                      = [ local_file.key_local_file ]

  disable_password_authentication = true
  admin_username                  = var.admin_user
  admin_ssh_key {
    username = var.admin_user
    #public_key = file( var.admin_ssh_pub_key )
    #public_key = file( local_file.key_local_file.filename )
    public_key  = tls_private_key.mykey.public_key_openssh
  }

  network_interface_ids = [ azurerm_network_interface.main.id ]

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip_address
    user        = self.admin_username
    private_key = file(var.key_file)
    #password   = self.admin_password
  }

  provisioner "file" {
    #source     = "webserver.sh"
    content     = ( var.provisioner_templatefile == "" ? "" : templatefile(var.provisioner_templatefile, {
      web_port  = var.pub_ingress_ports["web"][0]
    })
    )
    destination = "/tmp/remote-exec.sh"
  }

  provisioner "remote-exec" {
    #inline = [ "uptime", ]
    inline     = ( var.provisioner_templatefile == "" ?
      [ "true" ] : [
        "touch /tmp/.remote-exec",
        "echo 'remote-exec: $(hostname) IP address is ${self.public_ip_address})'",
        "chmod a+x /tmp/remote-exec.sh",
        "sh -x /tmp/remote-exec.sh"
      ]
    )
  }

}

