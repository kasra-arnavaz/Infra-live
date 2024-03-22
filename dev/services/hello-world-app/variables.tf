# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the module"
  default     = "my-hello-world-app"
}

variable "cluster_name" {
  description = "The name of the cluster"
  default     = "my-cluster"
}

variable "alb_name" {
  description = "The name of the Application Load Balancer"
  default     = "my-alb"
}
