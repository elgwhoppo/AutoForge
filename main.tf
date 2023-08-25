resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

resource "random_pet" "prefix" {
  length = 1
}

# create resource group
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "autoforge-${random_pet.prefix.id}-rg"
}

# Create virtual network
resource "azurerm_virtual_network" "lan_network" {
  name                = "${random_pet.prefix.id}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create DNS Zone
resource "azurerm_dns_zone" "landnszone" {
  name                = "lan.forgegaming.us"
  resource_group_name = azurerm_resource_group.rg.name
}

# Data block to retrieve DNS zone information
data "azurerm_dns_zone" "landnszone" {
  depends_on = [azurerm_dns_zone.landnszone]
  name                = "lan.forgegaming.us"
  resource_group_name = azurerm_resource_group.rg.name
}
/*
# Use the namecheap module to create NS delegate records in namecheap
module "namecheap_resources" {
  source = "./namecheap_dns"
  ns_records = azurerm_dns_zone.landnszone.name_servers
}
*/

# Create NS records in namecheap
resource "namecheap_domain_records" "forgegaming-us" {
  depends_on = [azurerm_dns_zone.landnszone]
  domain = "forgegaming.us"
  mode = "MERGE"

  dynamic "record" {
    for_each = data.azurerm_dns_zone.landnszone.name_servers

    content {
      hostname = "lan"
      type     = "NS"
      address  = record.value
    }
  }
  /*
  record {
    for_each = var.ns_records

    hostname = "lan"
    type = "NS"
    address = each.key
  }


  record {
    hostname = "testns"
    type = "NS"
    address = "ns1-34.azure-dns.com"
  }
  */
}

# Create subnet
resource "azurerm_subnet" "lan_subnet" {
  name                 = "${random_pet.prefix.id}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.lan_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics for all VMs
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

module "vm_tf2" {
  source         = "./vm_tf2"
  vm_name        = "autoforge-tf2"
  vm_size        = "Standard_DS1_v2"
  admin_username = "azureuser"
  allocation_method = "Static"
  subnet_id = azurerm_subnet.lan_subnet.id
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  admin_password = random_password.password.result
  dns_zone = azurerm_dns_zone.landnszone.name
}

output "module_tf2_info" {
  value = {
    tf2_public_ip = module.vm_tf2.tf2_public_ip_address
    tf2_public_dns = module.vm_tf2.tf2_dns_record
  }
}
module "vm_minecraft" {
  source         = "./vm_minecraft"
  vm_name        = "autoforge-minecraft"
  vm_size        = "Standard_DS1_v2"
  admin_username = "azureuser"
  allocation_method = "Static"
  subnet_id = azurerm_subnet.lan_subnet.id
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  admin_password = random_password.password.result
  dns_zone = azurerm_dns_zone.landnszone.name
}

output "module_minecraft_info" {
  value = {
    minecraft_public_ip = module.vm_minecraft.minecraft_public_ip_address
    minecraft_public_dns = module.vm_minecraft.minecraft_dns_record
  }
}

module "vm_pvkii" {
  source         = "./vm_pvkii"
  vm_name        = "autoforge-pvkii"
  vm_size        = "Standard_DS1_v2"
  admin_username = "azureuser"
  allocation_method = "Static"
  subnet_id = azurerm_subnet.lan_subnet.id
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  admin_password = random_password.password.result
  dns_zone = azurerm_dns_zone.landnszone.name
}

output "module_pvkii_info" {
  value = {
    pvkii_public_ip = module.vm_pvkii.pvkii_public_ip_address
    pvkii_public_dns = module.vm_pvkii.pvkii_dns_record
  }
}

module "vm_gm" {
  source         = "./vm_gm"
  vm_name        = "autoforge-gm"
  vm_size        = "Standard_DS1_v2"
  admin_username = "azureuser"
  allocation_method = "Static"
  subnet_id = azurerm_subnet.lan_subnet.id
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  admin_password = random_password.password.result
  dns_zone = azurerm_dns_zone.landnszone.name
}

output "module_gm_info" {
  value = {
    gm_public_ip = module.vm_gm.gm_public_ip_address
    gm_public_dns = module.vm_gm.gm_dns_record
  }
}