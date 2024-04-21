output "gophbank_db_address" {
  description = "The address of the gophbank_db"
  value       = module.env_resources.gophbank_db_address
  sensitive   = true
}

output "gophbank_created_db" {
  description = "The default database for gophbank_db"
  value       = module.env_resources.gophbank_created_db
  sensitive   = true
}

output "gophbank_db_username" {
  description = "The username for the gophbank_db"
  value       = module.env_resources.gophbank_db_username
  sensitive   = true
}

output "gophbank_db_password" {
  description = "The password for the gophbank_db"
  value       = module.env_resources.gophbank_db_password
  sensitive   = true
}