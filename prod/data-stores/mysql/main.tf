terraform {
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
  source      = "github.com/kasra-arnavaz/NN-modules//data-stores/mysql?ref=v0.8.0"
  db_username = var.db_username
  db_password = var.db_password
  env_name    = "prod"
  name        = "library"
  table       = "books"
}

terraform {
  backend "s3" {
    bucket         = "kasraz-state"
    key            = "prod/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "state-lock"
    encrypt        = true
  }
}
