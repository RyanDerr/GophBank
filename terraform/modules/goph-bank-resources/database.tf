variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "gophbank"
}

variable "postgres_version" {
  description = "The version of Postgres to use"
  type        = string
  default     = "16.2"
}

variable "postgres_instance_type" {
  description = "The instance type for the Postgres DB"
  type        = string
  default     = "db.t3.micro"
}

resource "random_password" "database_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&()*+,-.:;<=>?[]^_{|}~"
}

resource "aws_db_instance" "gophbank_db" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = var.postgres_version
  instance_class          = var.postgres_instance_type
  username                = "pgadmin"
  password                = random_password.database_admin_password.result
  db_name                 = var.db_name
  skip_final_snapshot     = true
  publicly_accessible     = true
  multi_az                = false
  identifier              = "${var.db_name}-${var.env}"
  backup_retention_period = 7

  tags = merge(
    local.common_tags,
  )
}