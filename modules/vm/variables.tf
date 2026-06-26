variable "name" {
  description = "Name of the VM"
  type        = string
}

variable "node_name" {
  description = "Proxmox node name to deploy the VM on"
  type        = string
}

variable "ciuser" {
  description = "Default user for cloud-init login"
  type        = string
  sensitive   = true
  default     = "ubuntu"
}

variable "cipassword" {
  description = "Password for the cloud-init user"
  type        = string
  sensitive   = true
  default     = null
}

variable "ssh_keys" {
  description = "List of SSH public keys for cloud-init user"
  type        = list(string)
  sensitive   = true
  default     = []
}

variable "ipconfig_ipv4" {
  description = "IPv4 address for the VM (e.g. 'dhcp' or '192.168.1.100/24')"
  type        = string
  default     = "dhcp"
}

variable "ipconfig_gateway" {
  description = "IPv4 gateway for the VM (optional, only if static IP)"
  type        = string
  default     = null
}

# vm configurations
variable "vm" {
  description = "VM configuration object"
  type = object({
    id     = number
    cores  = number
    cpu_type = string
    cpu_limit = number
    memory = number
    disk = object({
      datastore_id = string
      file_id      = string
      size         = number
      interface    = string
      iothread     = bool
      discard      = string
      replicate    = bool
      ssd          = bool
      backup       = bool
    })
    network_device = object({
      bridge = string
    })
  })
  default = {
    id     = 0
    cores  = 1
    cpu_type = "qemu64"
    cpu_limit = 0
    memory = 1024
    disk = {
      datastore_id = ""
      file_id      = ""
      size         = 20
      interface    = "virtio0"
      iothread     = true
      discard      = "on"
      replicate    = false
      ssd          = false
      backup       = true
    }
    network_device = {
      bridge = "vmbr0"
    }
  }
}