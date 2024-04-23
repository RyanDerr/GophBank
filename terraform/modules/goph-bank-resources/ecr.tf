resource "aws_ecr_repository" "gophbank_acr" {
  name                 = "gophbank-acr-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(
    local.common_tags,
  )
}