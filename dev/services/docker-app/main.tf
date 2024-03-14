terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "docker-app" {
  source        = "../../../../modules/services/docker-app"
  env_name      = "dev"
  min_size      = 1
  max_size      = 1
  instance_type = "t2.micro"
  server_port   = 5000
}
