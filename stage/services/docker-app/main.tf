terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
  }
}

provider "aws" {
  region = "us-east-2"
}

module "docker-app" {
  source                 = "github.com/kasra-arnavaz/NN-modules//services/docker-app?ref=v0.9.4"
  env_name               = var.env_name
  min_size               = 2
  max_size               = 2
  enable_scheduling      = false
  instance_type          = "t2.micro"
  server_port            = 5000
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key
}
