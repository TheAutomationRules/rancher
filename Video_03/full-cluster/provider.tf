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

# Rancher Provider bootstrap config
provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${aws_instance.rancher_server.public_ip}"
  bootstrap = true
  insecure  = true
}
provider "rancher2" {
  alias     = "admin"
  api_url   = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure  = true
}

# Rancher
provider "rancher2" {
  insecure = true
  /*api_url = "https://${var.rancher2_ip}/v3"
  token_key = var.bearer_token*/
  api_url = "https://${aws_instance.rancher_server.public_ip}/v3"
  token_key = rancher2_bootstrap.admin.token
}