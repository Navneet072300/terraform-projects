provider "aws" {
  region = "ap-south-1"  # Replace with your preferred region
}

resource "aws_kms_key" "demo_kms_key" {
  description             = "KMS key for demo credentials rotation"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_secretsmanager_secret" "demo_credentials" {
  name = "demo-credentials"
  kms_key_id = aws_kms_key.demo_kms_key.key_id
}

resource "aws_secretsmanager_secret_version" "demo_credentials_version" {
  secret_id     = aws_secretsmanager_secret.demo_credentials.id
  secret_string = jsonencode({
    username = "",
    password = ""
  })
}