provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create a new S3 bucket
resource "aws_s3_bucket" "new_bucket" {
  bucket = var.new_bucket_name
  tags = {
    Name        = "New Terraform S3 Bucket"
    Environment = "Dev"
  }
  force_destroy = true
}

# Manage an existing S3 bucket
resource "aws_s3_bucket" "imported_bucket" {
  bucket = var.existing_bucket_name
  tags = {
    Name = "Imported Terraform S3 Bucket"
  }
  force_destroy = false
}