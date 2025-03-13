variable "aws_region" {
  description = "The AWS region where the ECR repository will be created."
  type        = string
}

variable "ecr_repo_name" {
  description = "The name of the ECR repository."
  type        = string
}