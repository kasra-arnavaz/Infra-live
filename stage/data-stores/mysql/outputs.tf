output "address" {
  value       = module.mysql.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.mysql.port
  description = "The port the database is listening on"
}

output "name" {
  value       = module.mysql.name
  description = "The name of the database"
}

output "table" {
  value       = module.mysql.table
  description = "The name of the table in the database"
}

output "username" {
  value       = module.mysql.username
  description = "The username of the database"
  sensitive   = true
}

output "password" {
  value       = module.mysql.password
  description = "The password of the database"
  sensitive   = true
}
