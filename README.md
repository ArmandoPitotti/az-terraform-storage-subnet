# Overview

This Terraform project contains a template to add subnets to storage accounts.

## Usage

```hcl-terraform
module "subnet-access" {
  source = "git::ssh://git@gitlabe2.ext.net.nokia.com/cs/common/iac/az-terraform-stroage-subnet?ref=<version>"

  subnet_ids = [module.k8s.subnet_id]
  storage_account_name = module.spark.primary_storage_name
  resource_group_name  = azurerm_resource_group.core_rg.name
}
```

where `<version>` must be changed with the tag version that you want to refer to.

## Variables

In `variables.tf` file, the following variables have been defined:

| Name | Required | Default | Description |
| ---- | -------- | ------- | ----------- |
| `subnet_ids` | Yes | - | List of subnet IDs to allow access to storage account |
| `storage_account_name` | Yes | - | Name of the storage account |
| `resource_group_name` | Yes | - | Name of the resoure group of the storage account |
