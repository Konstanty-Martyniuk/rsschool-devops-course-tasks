terraform {
  backend "s3" {
    bucket         = "rs-dev-terraform-state-bucket"
    key            = "terraform/state.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true
  }
}
