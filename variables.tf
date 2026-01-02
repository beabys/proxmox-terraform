

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


variable "vms" {
  description = "List of VM objects to create"
  type = list(object({
    name            = string
    node_name       = string
    ciuser          = string
    cipassword      = string
    ssh_keys        = list(string)
    ipconfig_ipv4   = string
    ipconfig_gateway= string
    vm = object({
      id        = number
      cores     = number
      cpu_type  = string
      memory    = number
      disk      = object({
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
  }))
  default = []
}
