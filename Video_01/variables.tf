# VARS
variable "instance_type" { default = "t3a.medium" }
variable "docker_version" {default = "19.03"}
variable "private_ip" {default = "172.31.16.10"}
locals {
  node_username = "ubuntu"
}
variable "node_username" {}