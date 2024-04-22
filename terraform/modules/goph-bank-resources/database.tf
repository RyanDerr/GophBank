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

variable "postgres_username" {
  description = "The username for the Postgres DB"
  type        = string
  default     = "pgadmin"
}

resource "random_password" "database_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&()*+,-.:;<=>?[]^_{|}~"
}

resource "aws_security_group" "gophbank_db_sg" {
  name        = "gophbank_db_sg"
  description = "Allow inbound traffic on port 5432 for gophbank_db"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere for now
  }
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
  )
}

resource "aws_db_instance" "gophbank_db" {
  allocated_storage                   = 20
  storage_type                        = "gp2"
  engine                              = "postgres"
  engine_version                      = var.postgres_version
  instance_class                      = var.postgres_instance_type
  username                            = var.postgres_username
  password                            = random_password.database_admin_password.result
  db_name                             = var.db_name
  skip_final_snapshot                 = true
  publicly_accessible                 = true
  multi_az                            = false
  identifier                          = "${var.db_name}-${var.env}"
  backup_retention_period             = 7
  vpc_security_group_ids              = [aws_security_group.gophbank_db_sg.id]
  iam_database_authentication_enabled = true

  tags = merge(
    local.common_tags,
  )
}

output "gophbank_db_address" {
  description = "The address of the gophbank_db"
  value       = aws_db_instance.gophbank_db.address
  sensitive   = true
}

output "gophbank_created_db" {
  description = "The default database for gophbank_db"
  value       = aws_db_instance.gophbank_db.db_name
  sensitive   = true
}

output "gophbank_db_username" {
  description = "The username for the gophbank_db"
  value       = aws_db_instance.gophbank_db.username
  sensitive   = true
}

output "gophbank_db_password" {
  description = "The password for the gophbank_db"
  value       = aws_db_instance.gophbank_db.password
  sensitive   = true
}