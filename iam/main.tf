provider "aws" {
  region = "us-east-1"  # Change this as needed
}

resource "aws_iam_user" "example_user" {
  name = "terraform-user"
  force_destroy = true
}

resource "aws_iam_access_key" "example_key" {
  user = aws_iam_user.example_user.name
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.example_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" # Change policy as needed
}

output "access_key_id" {
  value = aws_iam_access_key.example_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.example_key.secret
  sensitive = true
}
