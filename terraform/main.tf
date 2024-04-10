locals {
  common_tags = {
    Owner       = "Ryan Derr"
    CreatedBy   = "terraform"
    Environment = "dev"
  }
}

variable "region" {
  description = "The region where AWS operations will take place"
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.region
}