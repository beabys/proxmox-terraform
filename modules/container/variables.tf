variable "hostname" {
  description = "Hostname of the container"
  type        = string
}

variable "node_name" {
  description = "Proxmox node name to deploy the container on"
  type        = string
}

variable "cipassword" {
  description = "Password for the root account"
  type        = string
  sensitive   = true
  default     = null
}

variable "ssh_keys" {
  description = "List of SSH public keys for root account"
  type        = list(string)
  sensitive   = true
  default     = []
}

variable "ipconfig_ipv4" {
  description = "IPv4 address for the container (e.g. 'dhcp' or '192.168.1.2/24')"
  type        = string
  default     = "dhcp"
}

variable "ipconfig_gateway" {
  description = "IPv4 gateway for the container (optional, only if static IP)"
  type        = string
  default     = null
}

# container configurations
variable "container" {
  description = "Container configuration object"
  type = object({
    id     = number
    cores  = number
    memory = number
    disk = object({
      datastore_id = string
      size         = number
    })
    template = object({
      file_id = string
      type    = string
    })
    network_interface = object({
      name   = string
      bridge = string
    })
    unprivileged = bool
    nesting      = bool
  })
  default = {
    id     = 0
    cores  = 1
    memory = 512
    disk = {
      datastore_id = ""
      size         = 8
    }
    template = {
      file_id = ""
      type    = "unmanaged"
    }
    network_interface = {
      name   = "veth0"
      bridge = "vmbr0"
    }
    unprivileged = false
    nesting      = false
  }
}
