# Data sources

# Cloud-Init Configuration
# ----------------------------------------------------------
data "template_file" "cloud-init-config" {
  template = file("./config/cloud-init.yaml")
  vars = {
    docker_version = var.docker_version
    username       = var.node_username
  }
}

# AWS CLOUD PROVIDER CREDENTIALS
# ----------------------------------------------------------
data "vault_generic_secret" "access_key" {
  path = "cloud/aws/staging/access_key"
}
data "vault_generic_secret" "secret_key" {
  path = "cloud/aws/staging/secret_key"
}
data "vault_generic_secret" "kms_key_id" {
  path = "cloud/aws/staging/kms_key_id"
}

# AWS Infrastructure Data
# ----------------------------------------------------------
data "aws_vpc" "vpc-id-staging" {
  filter {
    name   = "tag:Name"
    values = ["tar-vpc-default"]
  }
}
data "aws_subnet" "eu-central-1-1c" {
  filter {
    name   = "tag:Name"
    values = ["tar-subnet-eu-central-1a"]
  }
}

# Use latest Ubuntu 18.04 AMI
# ----------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}