# Provider
# HashiCorp Vault Provider
provider "vault" {
  address = "http://3.68.231.163:8200"
  token = "s.SdVK0I9dFCZnTLIqfDJHKvC5"
}

# AWS Cloud Provider
provider "aws" {
  region     = "eu-central-1"
  access_key = data.vault_generic_secret.access_key.data["access_key"]
  secret_key = data.vault_generic_secret.secret_key.data["secret_key"]
}

# Rancher
provider "rancher2" {
  insecure = true
  api_url = "https://${var.rancher2_ip}/v3"
  token_key = var.bearer_token
}