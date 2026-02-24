output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.devops_server.public_ip
}

output "private_key_path" {
  description = "Path to the generated private key PEM for Ansible"
  value       = local_file.devops_private_key.filename
}
