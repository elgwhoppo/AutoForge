variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "admin_username" {
  description = "Admin username for the VM"
  default     = "azureuser"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for the VM"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDm8I54XJfHxfdTuAlp7ThflTIo/NNWYkKMVG0KtSOQ4x9jJCkmzGx+rlmfgIKINquIzYX99Ifyqx7qs893VxB5O47MiLeyJMGYgjUpK9gVA1CWtPIoZHtS6HFfWoe9f6F82zgxl5CoVPOUVkQ4Nx5BfZCmvlJMRG2WIu8j6dW+djRrHKKWCGoGnaG4S5CPshpCIIaxUUSbs209hi6cmMROi1d3jc1Gw6Hb5ffXJQH4iFsjx0vPqODPt9jfijZzsQj0LPAf3+KokssUV26Aro9dWvVCsZeFB+beOsXijd9uaJPXriWWUyWSndP7r8B8EUVx7r25vt20jjvowm3Cy01zgQwVPt03KBBDQDSJnxQKIARHeqs7wVqrMetkrhKAcMMU/vPM6UjXu4im3hGBfKC1db+ZSUZpiMp4JIu8Uc1D0AHY8XRzpXI2czn5hBkN2GIoy/YIdoc7UsOprYmyYsRugyPaCvqOcUgunPWMC7VL0weNEpeVSh+X6FCjhTTuth0= joe@Isengard"
}