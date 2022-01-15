# Provider
# HashiCorp Vault Provider
provider "vault" {
  address = "http://35.157.39.210:8200"
  token = "s.vsmZPtLeyCi4HMBQ4OxjHtsg"
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