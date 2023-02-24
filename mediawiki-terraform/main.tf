# create resource group
resource "azurerm_resource_group" "tf_rg1" {
  name     = var.rg_name
  location = var.rg_location
}

# Create VNET
resource "azurerm_virtual_network" "tf_vnet1" {
  name                = "vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tf_rg1.location
  resource_group_name = azurerm_resource_group.tf_rg1.name
}

# Create subnet
resource "azurerm_subnet" "tf_subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.tf_rg1.name
  virtual_network_name = azurerm_virtual_network.tf_vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "tf_pub_ip1" {
  name                = "vm_pub_ip"
  resource_group_name = azurerm_resource_group.tf_rg1.name
  location            = azurerm_resource_group.tf_rg1.location
  allocation_method   = "Dynamic"
}

# Create NSG and rules
resource "azurerm_network_security_group" "tf_nsg1" {
  name                = "nsg1"
  resource_group_name = azurerm_resource_group.tf_rg1.name
  location            = azurerm_resource_group.tf_rg1.location
}

resource "azurerm_network_security_rule" "tf_ssh" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  description                 = "Allow inbound ssh"
  resource_group_name         = azurerm_resource_group.tf_rg1.name
  network_security_group_name = azurerm_network_security_group.tf_nsg1.name
}

resource "azurerm_network_security_rule" "tf_http" {
  name                        = "HTTP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  description                 = "Allow inbound http"
  resource_group_name         = azurerm_resource_group.tf_rg1.name
  network_security_group_name = azurerm_network_security_group.tf_nsg1.name
}

# resource "azurerm_network_security_rule" "tf_https" {
#   name                        = "HTTPS"
#   priority                    = 300
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   description                 = "Allow inbound https"
#   resource_group_name         = azurerm_resource_group.tf_rg1.name
#   network_security_group_name = azurerm_network_security_group.tf_nsg1.name
# }

# Create network interface
resource "azurerm_network_interface" "tf_nic1" {
  name                = "nic1"
  resource_group_name = azurerm_resource_group.tf_rg1.name
  location            = azurerm_resource_group.tf_rg1.location

  ip_configuration {
    name                          = "nic1_ip_config"
    subnet_id                     = azurerm_subnet.tf_subnet1.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.tf_pub_ip1.id
  }
}

# Apply NSG to VM NIC
resource "azurerm_network_interface_security_group_association" "tf_con1" {
  network_interface_id      = azurerm_network_interface.tf_nic1.id
  network_security_group_id = azurerm_network_security_group.tf_nsg1.id
}

# Create VM
resource "azurerm_linux_virtual_machine" "tf_vm1" {
  name                  = "RHEL-VM"
  resource_group_name   = azurerm_resource_group.tf_rg1.name
  location              = azurerm_resource_group.tf_rg1.location
  network_interface_ids = [azurerm_network_interface.tf_nic1.id]
  size                  = var.vm_size

  os_disk {
    name                 = "disk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-LVM"
    version   = "8.1.20200318"
  }

  computer_name                   = "rhelvm"
  admin_username                  = var.admin_user
  admin_password                  = var.admin_passwd
  disable_password_authentication = false

}