variable "subnet_ids" {
  type        = list
  description = "List of subnet IDs to allow access to storage account"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resoure group of the storage account"
}
