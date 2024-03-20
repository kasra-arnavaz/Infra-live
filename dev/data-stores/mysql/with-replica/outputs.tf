output "address" {
  value       = module.mysql_primary.address
  description = "Connect to the primary database at this endpoint"
}

output "port" {
  value       = module.mysql_primary.port
  description = "The port the primary database is listening on"
}

output "name" {
  value       = module.mysql_primary.name
  description = "The name of the primary database"
}

output "table" {
  value       = module.mysql_primary.table
  description = "The name of the table in the primary database"
}

output "arn" {
  value       = module.mysql_primary.arn
  description = "The ARN of the primary database"
}

output "username" {
  value       = module.mysql_primary.username
  description = "The username of the primary database"
  sensitive   = true
}

output "password" {
  value       = module.mysql_primary.password
  description = "The password of the primary database"
  sensitive   = true
}

output "replica_address" {
  value       = module.mysql_replica.address
  description = "The address of the replica database"
}

output "replica_port" {
  value       = module.mysql_replica.port
  description = "The port of the replica database"
}


