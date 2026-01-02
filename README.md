# Terraform Proxmox

This project provisions two VMs on Proxmox using the bpg/proxmox Terraform provider.

## Structure
- **main.tf**: Root configuration, provider, and module usage
- **variables.tf**: Input variables for provider and VMs
- **outputs.tf**: Outputs for VM IDs
- **modules/vm/**: Reusable VM module

## Provider
- Uses `bpg/proxmox` provider
- Credentials and endpoint should be set via variables or environment variables (see provider block in `main.tf`)

## Multi-VM Usage
This configuration supports creating multiple VMs by providing a `vms` list in `variables.tfvars`.

Example `variables.tfvars` snippet:

```hcl
vms = [
   {
      name = "vm1"
      node_name = "node"
      ciuser = "user"
      cipassword = "your_password"
      ssh_keys = ["ssh-key AAAA..."]
      ipconfig_ipv4 = "10.10.10.2/24"
      ipconfig_gateway = "10.10.10.1"
      vm = {
         id = 10
         cores = 2
         memory = 2048
         disk = {
            datastore_id = "local-lvm"
            file_id = "Backup:iso/noble-server-cloudimg-amd64.img"
            size = 20
            interface = "scsi0"
            iothread = true
            discard = "on"
         }
         network_device = { bridge = "vmbr0" }
      }
   }
]
```

Apply the configuration:

```bash
terraform init
terraform plan -var-file="variables.tfvars" -out=plan.plan
terraform apply plan.plan
```
