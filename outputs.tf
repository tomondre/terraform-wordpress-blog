output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}

output "db_username" {
  value     = local.db_username
  sensitive = true
}