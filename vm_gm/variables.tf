variable "vm_name" {
  description = "Name of the VM"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
}

variable "admin_password" {
  description = "Password for the virtual machine"
  sensitive = true
}

variable "vm_size" {
  description = "Size of the virtual machine"
}

variable "allocation_method" {
  description = "Allocation method for the public IP address"
}

variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "resource_group_location" {
  description = "Name of the resource group location"
}

variable "prefix" {
  description = "prefix"
}

variable "subnet_id" {
  description = "Subnet ID of the subnet to deploy into"
}

variable "dns_zone" {
  description = "name of the DNS zone to use"
}

