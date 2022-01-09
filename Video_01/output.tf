# Output
output "ip_addr" {
  value       = aws_instance.rancher_server.public_ip
  description = "The IP addresses of the deployed instances, paired with their IDs."
}

output "http_link" {
  value       = "http://${aws_instance.rancher_server.public_ip}"
  description = "HTTP Link Address"
}