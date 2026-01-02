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

## VM Module
- Module at `modules/vm` provisions a single VM
- Parameters: `name`, `node_name`, and more as needed

## Usage
1. Set required variables (see `variables.tf`)
2. Run:
   ```sh
   terraform init
   terraform plan -var="vm1_name=..." -var="vm1_node_name=..." -var="vm2_name=..." -var="vm2_node_name=..."
   terraform apply
   ```
3. Review outputs for VM IDs

## Multi-VM Usage (new)

This configuration now supports creating multiple VMs by providing a `vms` list in `variables.tfvars`.

Example `variables.tfvars` snippet:

```hcl
vms = [
   {
      name = "master1"
      node_name = "ryzen5"
      ciuser = "beabys"
      cipassword = "5283151014"
      ssh_keys = ["ssh-rsa AAAA..."]
      ipconfig_ipv4 = "10.27.10.51/24"
      ipconfig_gateway = "10.27.10.1"
      vm = {
         id = 100
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
terraform plan -var-file="variables.tfvars" -out=plan.out
terraform apply plan.out
```
