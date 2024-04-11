module "dev_resources" {
  source = "../../modules/goph-bank-resources"
  env    = "dev"
  region = "us-east-1"
}