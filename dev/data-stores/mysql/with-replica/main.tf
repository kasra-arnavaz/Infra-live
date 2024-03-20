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
  alias  = "primary"
}

provider "aws" {
  region = "us-west-2"
  alias  = "replica"
}

module "mysql_primary" {
  source                  = "../../../../../modules/data-stores/mysql"
  env_name                = local.name
  name                    = "library"
  table                   = "books"
  db_username             = var.db_username
  db_password             = var.db_password
  backup_retention_period = 1
  providers = {
    aws = aws.primary
  }
}

module "mysql_replica" {
  source              = "../../../../../modules/data-stores/mysql"
  env_name            = local.name
  replicate_source_db = module.mysql_primary.arn
  providers = {
    aws = aws.replica
  }
}

locals {
  name = "multi-region-db"
}

