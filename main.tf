locals {
  subnet_ids = join(" ", var.subnet_ids)
}

resource "null_resource" "storage-account-subnets" {
  triggers = {
    subnet_ids          = local.subnet_ids
    storage_name        = var.storage_account_name
    resource_group_name = var.resource_group_name
    do                  = true
  }

  provisioner "local-exec" {
    command = <<EOT
    set +e

    misc-lockfile lock /tmp/lock-storage-subnet
    trap "misc-lockfile unlock /tmp/lock-storage-subnet" EXIT

    subnets="${local.subnet_ids}"
    existing_subnets=$(az storage account network-rule list -g ${var.resource_group_name} --account-name ${var.storage_account_name} --output tsv --query virtualNetworkRules[].virtualNetworkResourceId)

    for subnet in $subnets; do
      exists="false"
      for existing_subnet in $existing_subnets; do
        if [ "$existing_subnet" = "$subnet" ]; then
          exists="true"
          break
        fi
      done

      [ "$exists" = "false" ] || continue

      az storage account network-rule add -g ${var.resource_group_name} --account-name ${var.storage_account_name} --subnet $subnet
    done
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
    set +e

    misc-lockfile lock /tmp/lock-storage-subnet
    trap "misc-lockfile unlock /tmp/lock-storage-subnet" EXIT

    subnets="${self.triggers.subnet_ids}"

    for subnet in $subnets; do
      az storage account network-rule remove -g ${self.triggers.resource_group_name} --account-name ${self.triggers.storage_name} --subnet $subnet || true
    done

    EOT
  }
}
