variable "aws_account_id" {
  description = "AWS account ID."
  type        = string
}

variable "aws_region" {
  description = "AWS region for resource deployment."
  type        = string
  default     = "eu-north-1"
}

variable "required_iam_policies" {
  description = "Required IAM policies for GitHub Actions."
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess"
  ]
}

variable "terraform_dynamodb_access_allowed_actions" {
  description = "List of allowed DynamoDB actions for Terraform."
  type        = list(string)
  default = [
    "dynamodb:DeleteItem",
    "dynamodb:DescribeContinuousBackups",
    "dynamodb:DescribeTable",
    "dynamodb:DescribeTimeToLive",
    "dynamodb:GetItem",
    "dynamodb:ListTagsOfResource",
    "dynamodb:PutItem"
  ]
}

variable "terraform_environment" {
  description = "Deployment environment."
  type        = string
  default     = "prod"
}

variable "terraform_github_actions_role_name" {
  description = "GitHub Actions IAM role name."
  type        = string
  default     = "GithubActionsRole"
}

variable "terraform_state_lock_table_name" {
  description = "DynamoDB table name for storing Terraform locking state."
  type        = string
  default     = "terraform-state-lock-table"
}

variable "terraform_state_s3_bucket_name" {
  description = "S3 bucket name for storing Terraform state."
  type        = string
  default     = "rs-dev-terraform-state-bucket"
}
