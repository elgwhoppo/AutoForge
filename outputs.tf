output "public_ip_address" {
  value = azurerm_public_ip.example.ip_address
}

output "public_dns_name" {
  value = azurerm_dns_a_record.example.fqdn
}
