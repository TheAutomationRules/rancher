# VARS
variable "instance_type" { default = "t3a.medium" }
variable "docker_version" {default = "19.03"}
variable "private_ip" {default = "172.31.16.10"}
variable "node_username" {default = "ubuntu"}

# --- Cluster VARS -----------------------------------------------
variable "aws_region" {default = "eu-central-1"}
#variable "iam_instance_profile" {default = "ec2-instance-profile-staging"}
variable "k8version" {default = "v1.20.6-rancher1-1"}
/*
variable "rancher2_ip" {}
variable "bearer_token" {}
*/
