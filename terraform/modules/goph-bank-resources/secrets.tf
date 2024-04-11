resource "aws_secretsmanager_secret" "pg_password" {
  name        = "gophbank-${var.env}-pg-password"
  description = "The password for the PostgreSQL database"
}

resource "aws_secretsmanager_secret_version" "pg_password" {
  secret_id     = aws_secretsmanager_secret.pg_password.id
  secret_string = aws_db_instance.gophbank_db.password
}