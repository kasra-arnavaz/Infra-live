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
  source                 = "github.com/kasra-arnavaz/NN-modules//services/docker-app?ref=v0.8.0"
  env_name               = "prod"
  min_size               = 2
  max_size               = 5
  enable_scheduling      = true
  instance_type          = "t2.micro"
  server_port            = 5000
  db_remote_state_bucket = "kasraz-state"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
}

terraform {
  backend "s3" {
    bucket         = "kasraz-state"
    key            = "prod/services/docker-app/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "state-lock"
    encrypt        = true
  }
}
