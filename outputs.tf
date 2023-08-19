output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "admin_password" {
  sensitive = true
  value     = random_password.password.result
}


/*
output "tf2_public_ip_address" {
  value = azurerm_linux_virtual_machine.tf2_server.public_ip_address
}



output "pvkii_public_ip_address" {
  value = azurerm_linux_virtual_machine.pvkii_server.public_ip_address
}

output "pvkii_admin_password" {
  sensitive = true
  value     = azurerm_linux_virtual_machine.pvkii_server.admin_password
}
*/