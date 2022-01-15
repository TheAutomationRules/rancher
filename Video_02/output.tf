# Output Sensitive Information
output "rancher_public_ip" {
  value = aws_instance.rancher_server.public_ip
}
output "rancher_admin_password" {
  value = nonsensitive(random_password.password.result)
}
output "rancher_admin_url" {
  value = rancher2_bootstrap.admin.url
}
output "rancher_admin_token" {
  value = nonsensitive(rancher2_bootstrap.admin.token)
}