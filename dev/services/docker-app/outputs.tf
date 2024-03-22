output "alb_dns_name" {
  value       = module.docker-app.alb_dns_name
  description = "The domain name of the load balancer to connect to"
}

output "db_address" {
  value       = module.mysql.address
  description = "The address of the MySQL database"
}

output "db_port" {
  value       = module.mysql.port
  description = "The port of the MySQL database"
}
