terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {} # Change if you want remote backend
}

provider "aws" {
  region = var.aws_region
}
