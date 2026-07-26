data "azurerm_client_config" "current" {}

locals {
  key_vault_secrets = merge([
    for key_vault_key, key_vault in var.key_vault : {
      for secret_key, secret in key_vault.secrets : "${key_vault_key}-${secret_key}" => {
        name          = secret.name
        value         = secret.value
        key_vault_key = key_vault_key
      }
    }
  ]...)
}

resource "azurerm_key_vault" "key_vault" {
  for_each                    = var.key_vault
  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = each.value.sku_name
  soft_delete_retention_days  = each.value.soft_delete_retention_days
  purge_protection_enabled    = each.value.purge_protection_enabled
  enabled_for_disk_encryption = each.value.enabled_for_disk_encryption

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = each.value.secret_permissions
  }
}

resource "azurerm_key_vault_secret" "secret" {
  for_each     = local.key_vault_secrets
  name         = each.value.name
  value        = each.value.value
  key_vault_id = azurerm_key_vault.key_vault[each.value.key_vault_key].id
}
