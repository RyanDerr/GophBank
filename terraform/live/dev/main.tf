variable "account_id" {
  description = "AWS account id"
  default     = ""
}

module "env_resources" {
  source                  = "../../modules/goph-bank-resources"
  env                     = "dev"
  region                  = "us-east-1"
  account_id              = var.account_id
  db_password_secret_name = "gophbank-db-password-dev"
}