locals {
  common_tags = {
    Owner       = "Ryan Derr"
    CreatedBy   = "terraform"
    Environment = var.env
  }
}

variable "region" {
  description = "The region where AWS operations will take place"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "The environment for the resources"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.env)
    error_message = "The env variable must be 'dev', 'test', or 'prod'."
  }
}

provider "aws" {
  region = var.region
}