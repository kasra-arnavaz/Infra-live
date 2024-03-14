output "alb_dns_name" {
  value       = module.docker-app.alb_dns_name
  description = "The domain name of the load balancer to connect to"
}
