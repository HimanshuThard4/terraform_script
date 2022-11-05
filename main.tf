terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0e6329e222e662a52"
  instance_type = "t2.micro"
  key_name = var.key_name

  tags = {
    Name = var.instance_name
  }
}
