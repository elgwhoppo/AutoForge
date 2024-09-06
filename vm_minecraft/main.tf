# Other resources and configurations
# Create Minecraft Server

# Create server public IPs
resource "azurerm_public_ip" "minecraft_public_ip" {
  name                = "${var.vm_name}-public-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "minecraft_nsg" {
  name                = "${var.vm_name}-nsg-minecraft"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

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
    name                       = "minecraft"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "25565"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create minecraft network interface
resource "azurerm_network_interface" "minecraft_nic" {
  name                = "${var.vm_name}-nic-minecraft"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-nic-configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.minecraft_public_ip.id
  }
}

# Connect the minecraft security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.minecraft_nic.id
  network_security_group_id = azurerm_network_security_group.minecraft_nsg.id
}


# Create minecraft virtual machine
resource "azurerm_linux_virtual_machine" "minecraft_server" {
  name                  = var.vm_name
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.minecraft_nic.id]
  disable_password_authentication = false
  size                  = var.vm_size
  #size                 = "Standard_DS11_v2" #this for minecraft bigger heap size

  admin_ssh_key {
    username   = var.admin_username  # Change this to your desired admin username
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDm8I54XJfHxfdTuAlp7ThflTIo/NNWYkKMVG0KtSOQ4x9jJCkmzGx+rlmfgIKINquIzYX99Ifyqx7qs893VxB5O47MiLeyJMGYgjUpK9gVA1CWtPIoZHtS6HFfWoe9f6F82zgxl5CoVPOUVkQ4Nx5BfZCmvlJMRG2WIu8j6dW+djRrHKKWCGoGnaG4S5CPshpCIIaxUUSbs209hi6cmMROi1d3jc1Gw6Hb5ffXJQH4iFsjx0vPqODPt9jfijZzsQj0LPAf3+KokssUV26Aro9dWvVCsZeFB+beOsXijd9uaJPXriWWUyWSndP7r8B8EUVx7r25vt20jjvowm3Cy01zgQwVPt03KBBDQDSJnxQKIARHeqs7wVqrMetkrhKAcMMU/vPM6UjXu4im3hGBfKC1db+ZSUZpiMp4JIu8Uc1D0AHY8XRzpXI2czn5hBkN2GIoy/YIdoc7UsOprYmyYsRugyPaCvqOcUgunPWMC7VL0weNEpeVSh+X6FCjhTTuth0= joe@Isengard"  # Change this to your SSH public key content
  }

  os_disk {
    name                 = "minecraftOsDisk"
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
    user     = azurerm_linux_virtual_machine.minecraft_server.admin_username
    password = var.admin_password
    //use the public IP of this host
    //host     = azurerm_public_ip.minecraft_public_ip.ip_address
    host = self.public_ip_address
  }

  // commands to install LinuxGSM and minecraft server and depednencies
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install git -y",
      "git clone https://github.com/elgwhoppo/AutoForge.git ~/AutoForge",
      "cd ~/AutoForge/Gameservers",
      "chmod +x *",
      "./prep_server.sh",
      "./minecraft_update_and_run.sh",
    ]
  }
}

//need to do remote provisioner without destroying the VM on apply
//https://www.terraform.io/language/resources/provisioners/remote-exec

resource "azurerm_dns_a_record" "minecraft_record" {
  name                = "minecraft"
  zone_name           = var.dns_zone
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_public_ip.minecraft_public_ip.ip_address]
  depends_on          = [azurerm_linux_virtual_machine.minecraft_server]
}

output "minecraft_public_ip_address" {
  value = azurerm_public_ip.minecraft_public_ip.ip_address
}

output "minecraft_dns_record" {
  value = azurerm_dns_a_record.minecraft_record.fqdn
}