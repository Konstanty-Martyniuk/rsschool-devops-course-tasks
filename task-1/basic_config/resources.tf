# S3 bucket for storing Terraform state
resource "aws_s3_bucket" "terraform_state_s3_bucket" {
  bucket = var.terraform_state_s3_bucket_name

  tags = {
    Name        = var.terraform_state_s3_bucket_name
    Environment = var.terraform_environment
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_s3_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table for storing Terraform locking state
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.terraform_state_lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = var.terraform_state_lock_table_name
    Environment = var.terraform_environment
  }
}

# IAM role for GitHub Actions
resource "aws_iam_role" "terraform_github_actions_role" {
  name               = var.terraform_github_actions_role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_policy.json

  tags = {
    Name        = var.terraform_github_actions_role_name
    Environment = var.terraform_environment
  }
}

data "aws_iam_policy_document" "github_actions_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions_IODC_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Konstanty-Martyniuk/rsschool-devops-course-tasks:*"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "required_iam_policies" {
  for_each   = toset(var.required_iam_policies)
  role       = aws_iam_role.terraform_github_actions_role.name
  policy_arn = each.value
}

resource "aws_iam_policy" "terraform_dynamodb_access_policy" {
  name        = "DynamoDBTerraformServiceRolePolicy"
  description = "Custom service role policy for Terraform to access DynamoDB for state locking."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.terraform_dynamodb_access_allowed_actions
        Resource = "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.terraform_state_lock_table_name}"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_dynamodb_access" {
  role       = aws_iam_role.terraform_github_actions_role.name
  policy_arn = aws_iam_policy.terraform_dynamodb_access_policy.arn
}

resource "aws_iam_openid_connect_provider" "github_actions_IODC_provider" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]

  tags = {
    Name        = "GitHub Actions OIDC Provider"
    Environment = var.terraform_environment
  }
}
