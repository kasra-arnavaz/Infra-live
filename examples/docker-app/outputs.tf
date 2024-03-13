output "alb_dns_name" {
  value       = module.ami-docker-example
  description = "The domain name of the load balancer to connect to"
}
