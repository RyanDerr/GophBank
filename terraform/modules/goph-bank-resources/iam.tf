variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

resource "aws_iam_policy" "gophbank_db_policy" {
  name        = "gophbank_db_policy"
  description = "Policy to allow GophBankUsers to connect to RDS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "rds-db:connect",
        Resource = "arn:aws:rds-db:${var.region}:${var.account_id}:dbuser:${aws_db_instance.gophbank_db.resource_id}/${var.postgres_username}"
      },
    ],
  })
}

resource "aws_iam_group_policy_attachment" "gophbank_users_db_policy_attachment" {
  group      = "GophBankUsers"
  policy_arn = aws_iam_policy.gophbank_db_policy.arn
}