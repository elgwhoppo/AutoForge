output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "admin_password" {
  sensitive = true
  value     = random_password.password.result
}

# Output the NS records for this implementation in Azure, that should be pushed to namecheap
output "ns_records" {
  value = azurerm_dns_zone.landnszone.name_servers
}