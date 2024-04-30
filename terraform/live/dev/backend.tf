terraform {
  required_version = ">= 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.44"
    }
  }
  backend "s3" {
    encrypt = true
    key     = "gophbank-dev.tfstate"
  }
}