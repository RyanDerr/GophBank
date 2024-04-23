variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "usergroup_name" {
  description = "The name of the IAM group for GophBank users"
  type        = string
  default     = "GophBankUsers"
}

variable "db_iam_user" {
  type        = string
  description = "The name of the IAM user for the database"
  default     = "db_domain_users"
}


resource "aws_iam_policy" "gophbank_db_policy" {
  name        = "GophBankDBPolicy"
  description = "Policy for IAM user to connect to RDS instance"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rds-db:connect"
        ],
        Resource = [
          "arn:aws:rds-db:${var.region}:${var.account_id}:dbuser:${aws_db_instance.gophbank_db.resource_id}/${var.db_iam_user}"
        ]
      }
    ]
  })

  tags = merge(
    local.common_tags
  )
}

resource "aws_iam_group_policy_attachment" "gophbank_db_policy_attachment" {
  group      = var.usergroup_name
  policy_arn = aws_iam_policy.gophbank_db_policy.arn
}