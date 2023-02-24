output "vm_public_ip" {
  value = azurerm_linux_virtual_machine.tf_vm1.public_ip_address
}

output "vm_admin_username" {
  value = azurerm_linux_virtual_machine.tf_vm1.admin_username
}