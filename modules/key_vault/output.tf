output "secret_values" {
  value = {
    for key, secret in azurerm_key_vault_secret.secret : key => secret.value
  }
  sensitive = true
}
