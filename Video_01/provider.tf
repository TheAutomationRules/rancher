# Provider
# HashiCorp Vault Provider
provider "vault" {
  address = "http://18.184.208.84:8200"
  token = "s.wK4BU17b2bC3MmqMsB9jvbhT"
}

# AWS Cloud Provider
provider "aws" {
  region     = "eu-central-1"
  access_key = data.vault_generic_secret.access_key.data["access_key"]
  secret_key = data.vault_generic_secret.secret_key.data["secret_key"]
}