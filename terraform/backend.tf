terraform {
  required_version = ">= 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.44"
    }
  }
  backend "s3" {
    bucket         = "gophbank-terraform-state-storage"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "gophbank-terraform-lock"
    encrypt        = true
  }
}