module "env_resources" {
  source                  = "../../modules/goph-bank-resources"
  env                     = "dev"
  region                  = "us-east-1"
  db_password_secret_name = "gophbank-dev-postgres-password"
}