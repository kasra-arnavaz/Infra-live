output "alb_dns_name" {
  value       = module.hello-world-app-example
  description = "The domain name of the load balancer to connect to"
}
