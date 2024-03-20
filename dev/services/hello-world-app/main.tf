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

module "hello-world-app" {
  source        = "../../../../modules/services/hello-world-app"
  env_name      = var.env_name
  min_size      = 1
  max_size      = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  server_text   = "Hello, World"

}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
