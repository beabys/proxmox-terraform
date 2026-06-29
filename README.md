# proxmox-terraform

Terraform project for provisioning VMs and containers on Proxmox using the `bpg/proxmox` provider.

This repository is the infrastructure foundation for a homelab environment, with support for reusable modules, multi-instance provisioning, and parameterized VM definitions for repeatable infrastructure setup.

## Overview

This project provisions multiple Proxmox workloads through Terraform.

The current repository includes:

- A reusable `modules/` structure.
- Root Terraform files for provider, variables, outputs, and orchestration.
- Support for provisioning multiple VMs from a `vms` list.
- Recent support for **containers** in addition to VMs.
- Provider configuration using the `bpg/proxmox` provider.

It is designed for homelab infrastructure that can later be consumed by projects such as Kubernetes clusters, support services, or other self-hosted workloads.

## Goals

- Provision Proxmox infrastructure in a repeatable way.
- Define machine configuration as code.
- Reuse modules instead of duplicating infrastructure definitions.
- Support multiple machines from a single configuration.
- Reduce manual setup and make environment rebuilds easier.

## Why this project exists

Creating VMs manually in the Proxmox UI is fine for small experiments, but it becomes harder to maintain as the number of machines, roles, and changes grows.

This repository exists to make infrastructure:

- Repeatable.
- Easier to review.
- Easier to evolve.
- Better aligned with platform engineering workflows.

## Current structure

Based on the repository contents, the project currently contains:

```text
.
├── main.tf
├── outputs.tf
├── providers.tf
├── variables.tf
├── versions.tf
├── modules/
└── README.md
```

The `modules/` directory is the reusable core of the project, while the root configuration wires provider configuration and machine definitions together.

## Provider

This project uses the [`bpg/proxmox`](https://github.com/bpg/terraform-provider-proxmox) Terraform provider.

Provider credentials and endpoint values should be supplied through variables or environment variables rather than hardcoded in source files.

## What it provisions

The project is intended to provision one or more Proxmox workloads, currently centered on VMs and containers.

Typical use cases include:

- Kubernetes control plane nodes.
- Kubernetes worker nodes.
- LXC containers for support services.
- Utility hosts for observability, reverse proxies, or experimentation.

## Multi-instance usage

One of the key strengths of this repository is support for provisioning multiple machines through a `vms` definition list.

This allows a single Terraform run to define several machines with different compute, storage, and networking settings while keeping the overall structure reusable.

## Example configuration

Create a new file `variables.tfvars`, here's an example of configuration:

```hcl
proxmox = {
  endpoint             = "https://your-proxmox-host:8006/"
  api_token            = "your-api-token"
  insecure             = true
  ssh_private_key_path = "~/.ssh/id_rsa"
  ssh_user             = "your-node-user"
}

vms = [
  {
    name             = "vm1"
    node_name        = "node"
    ciuser           = "user"
    cipassword       = "your_password"
    ssh_keys         = ["ssh-ed25519 AAAA..."]
    ipconfig_ipv4    = "10.10.10.2/24"
    ipconfig_gateway = "10.10.10.1"

    vm = {
      id        = 10
      cores     = 2
      cpu_limit = 2.0
      memory    = 2048
      disk = {
        datastore_id = "local-lvm"
        file_id      = "Backup:iso/noble-server-cloudimg-amd64.img"
        size         = 20
        interface    = "scsi0"
        iothread     = true
        discard      = "on"
      }
      network_device = {
        bridge = "vmbr0"
      }
    }
  }
]

containers = [
  {
    hostname         = "lxc1"
    node_name        = "node"
    cipassword       = "your_password"
    ssh_keys         = ["ssh-ed25519 AAAA..."]
    ipconfig_ipv4    = "10.10.10.3/24"
    ipconfig_gateway = "10.10.10.1"
    container = {
      id     = 101
      cores  = 2
      memory = 4096
      disk = {
        datastore_id = "local-lvm"
        size         = 32
      }
      template = {
        file_id = "Backup:vztmpl/ubuntu-26.04-standard_26.04-1_amd64.tar.zst"
        type    = "ubuntu"
      }
      network_interface = {
        name   = "eth0"
        bridge = "vmbr0"
      }
      unprivileged = true
      nesting      = true
    }
  }
]
```

Adjust the exact field names as your module evolves.

## Usage

Initialize, plan, and apply the configuration with a tfvars file:

```bash
terraform init
terraform plan -var-file="variables.tfvars" -out=plan.plan
terraform apply plan.plan
```

## Inputs

The repository currently expects values in two main areas:

- **Provider configuration**, such as endpoint, token, SSH user, and SSH private key path.
- **Machine/Containers definitions**, such as VM/LXC name, node target, network configuration, cloud-init/template values, disk settings, and CPU/memory sizing.

Suggested documentation table for future expansion:

| Variable | Description |
|---|---|
| `proxmox` | Proxmox endpoint, auth, and SSH-related configuration |
| `vms` | List of VM definitions to create |
| `containers` | List of LXC containers definitions to create |

## Outputs

The repository already includes an `outputs.tf` file. A natural use for outputs here is to expose information such as:

- VM/Container IDs.
- VM/Container names.
- Assigned IP addresses.
- Machine metadata that can feed later automation layers.

This is especially useful when integrating with Ansible or a cluster bootstrap process.

## Operational notes

A few important operational considerations for this repository:

- Some infrastructure changes may force recreation depending on provider behavior.
- Image, datastore, and bridge names must exist in Proxmox before apply.
- Sensitive values such as API tokens should not be committed to the repository.
- Reusable modules are most valuable when machine shapes and conventions stay consistent.

## Why this project matters

This repository demonstrates practical infrastructure-as-code skills in a self-hosted environment:

- Terraform module design.
- Multi-instance provisioning.
- Infrastructure reuse.
- Integration-friendly outputs.
- A clean foundation for higher-level automation.

It also makes a good bridge between homelab work and cloud/platform engineering because the same habits apply: declarative infrastructure, reviewable changes, and repeatable rebuilds.

## Integration with other projects

This repository is best used as the foundation layer for other projects, for example:

- [`k3s-cluster`](https://github.com/beabys/k3s-cluster) for Kubernetes bootstrap and platform services.
- Observability or sandbox environments built on top of these machines.

## Roadmap

Useful next improvements could include:

- [ ] Expand module coverage for more workload types.
- [ ] Generate outputs suitable for Ansible inventory.
- [ ] Add examples for VM-only and container-only deployments.
- [ ] Add validation rules and formatting/lint checks.
- [ ] Add environment-specific examples.
- [ ] Document migration and replacement behavior more clearly.

## Getting started

```bash
git clone https://github.com/beabys/proxmox-terraform.git
cd proxmox-terraform
```
create configuration file `variables.tfvars`

```
terraform init
terraform plan -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars"
```
