variable "access_key" {
  description = "Access key to AWS console"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Secret key to AWS console"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "new_bucket_name" {
  description = "Name of the new S3 bucket to create"
  type        = string
  default     = "terraform-new-s3buc"
}

variable "existing_bucket_name" {
  description = "Name of the existing S3 bucket to import"
  type        = string
  default     = "terraform-s3buc"
}