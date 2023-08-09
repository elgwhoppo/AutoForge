# create resource grouplan_network
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "${random_pet.prefix.id}-rg"
}

# Create virtual network
resource "azurerm_virtual_network" "lan_network" {
  name                = "${random_pet.prefix.id}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "lan_subnet" {
  name                 = "${random_pet.prefix.id}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.lan_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create tf2 server public IPs
resource "azurerm_public_ip" "tf2_public_ip" {
  name                = "${random_pet.prefix.id}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create TF2 Network Security Group and rules
resource "azurerm_network_security_group" "tf2_nsg" {
  name                = "${random_pet.prefix.id}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ssh"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "tf2"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "27000-27050"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "tf2-all"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3478-4380"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create TF2 network interface
resource "azurerm_network_interface" "tf2_nic" {
  name                = "${random_pet.prefix.id}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.lan_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf2_public_ip.id
  }
}

# Connect the TF2 security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.tf2_nic.id
  network_security_group_id = azurerm_network_security_group.tf2_nsg.id
}

# Create TF2 torage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Create TF2 virtual machine
resource "azurerm_linux_virtual_machine" "tf2_server" {
  name                  = "tf2-vm"
  admin_username        = "azureuser"
  admin_password        = random_password.password.result
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.tf2_nic.id]
  disable_password_authentication = false
  size                  = "Standard_DS1_v2"

  admin_ssh_key {
    username   = "azureuser"  # Change this to your desired admin username
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDm8I54XJfHxfdTuAlp7ThflTIo/NNWYkKMVG0KtSOQ4x9jJCkmzGx+rlmfgIKINquIzYX99Ifyqx7qs893VxB5O47MiLeyJMGYgjUpK9gVA1CWtPIoZHtS6HFfWoe9f6F82zgxl5CoVPOUVkQ4Nx5BfZCmvlJMRG2WIu8j6dW+djRrHKKWCGoGnaG4S5CPshpCIIaxUUSbs209hi6cmMROi1d3jc1Gw6Hb5ffXJQH4iFsjx0vPqODPt9jfijZzsQj0LPAf3+KokssUV26Aro9dWvVCsZeFB+beOsXijd9uaJPXriWWUyWSndP7r8B8EUVx7r25vt20jjvowm3Cy01zgQwVPt03KBBDQDSJnxQKIARHeqs7wVqrMetkrhKAcMMU/vPM6UjXu4im3hGBfKC1db+ZSUZpiMp4JIu8Uc1D0AHY8XRzpXI2czn5hBkN2GIoy/YIdoc7UsOprYmyYsRugyPaCvqOcUgunPWMC7VL0weNEpeVSh+X6FCjhTTuth0= joe@Isengard"  # Change this to your SSH public key content
  }

  os_disk {
    name                 = "tf2OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = "100"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  connection {
    type     = "ssh"
    user     = azurerm_linux_virtual_machine.tf2_server.admin_username
    password = random_password.password.result
    //use the public IP of this host
    //host     = azurerm_public_ip.tf2_public_ip.ip_address
    host = self.public_ip_address
  }

  // commands to install LinuxGSM and TF2 server and depednencies
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install git -y",
      "git clone https://github.com/elgwhoppo/AutoForge.git ~/AutoForge",
      "cd ~/AutoForge/Gameservers",      
      "chmod +x *",
      "./prep_server.sh",
      "./install_tf2.sh"
    ]
  }
}

//need to do remote provisioner without destroying the VM on apply
//https://www.terraform.io/language/resources/provisioners/remote-exec

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}

resource "azurerm_dns_zone" "landnszone" {
  name                = "lan.forgegaming.us"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_a_record" "tf2_record" {
  name                = "tf2"
  zone_name           = azurerm_dns_zone.landnszone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  records             = [azurerm_public_ip.tf2_public_ip.ip_address]
}