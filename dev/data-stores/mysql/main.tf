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

module "mysql" {
  source      = "../../../../modules/data-stores/mysql"
  db_username = var.db_username
  db_password = var.db_password
  env_name    = "dev"
  name        = "library"
  table       = "books"
}

terraform {
  backend "s3" {
    bucket         = "kasraz-state"
    key            = "dev/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "state-lock"
    encrypt        = true
  }
}

