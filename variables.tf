

variable "proxmox" {
  description = "Proxmox API connection settings (endpoint, token, TLS and SSH helper settings)"
  type = object({
    endpoint              = string
    api_token             = string
    insecure              = bool
    ssh_user              = string
    ssh_private_key_path  = string
  })
  default = {
    endpoint             = ""
    api_token            = ""
    insecure             = false
    ssh_user             = "root"
    ssh_private_key_path = ""
  }
}

# Proxmox VM1 cloud-init variables
variable "master" {
  description = "VM1 configuration object"
  type = object({
    name            = string
    node_name       = string
    ciuser          = string
    cipassword      = string
    ssh_keys        = list(string)
    ipconfig_ipv4   = string
    ipconfig_gateway= string
    id              = number
    cores           = number
    memory          = number
    disk = object({
      datastore_id = string
      file_id      = string
      size         = number
      interface    = string
      iothread     = bool
      discard      = string
    })
    network_device = object({
      bridge = string
    })
  })
  default = {
    name            = ""
    node_name       = ""
    ciuser          = "ubuntu"
    cipassword      = ""
    ssh_keys        = []
    ipconfig_ipv4   = "dhcp"
    ipconfig_gateway= ""
    file_id         = ""
    id              = 0
    cores           = 1
    memory          = 1024
    disk = {
      datastore_id = ""
      file_id      = ""
      size         = 20
      interface    = "virtio0"
      iothread     = true
      discard      = "on"
    }
    network_device = {
      bridge = "vmbr0"
    }
  }
}

