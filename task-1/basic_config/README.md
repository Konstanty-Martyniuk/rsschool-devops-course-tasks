### How to Use

1. **Initialize Terraform:**
    - Comment out the Terraform backend configuration in `main.tf`.
    - Run the command: `terraform init`.

2. **Plan and Apply Changes:**
    - Review changes with: `terraform plan`.
    - Apply changes using: `terraform apply`.

3. **Migrate to S3 Backend:**
    - Uncomment the Terraform backend configuration in `main.tf`.
    - Initialize Terraform again with: `terraform init`.

4. **Plan and Apply Changes Again:**
    - Review changes once more with: `terraform plan`.
    - Apply changes using: `terraform apply`.

Now Terraform up and running using an S3 bucket and DynamoDB as a backend.

## Configuration and Secrets

For local development, the AWS Account ID variable `aws_account_id` is stored in the `terraform.tfvars` file, 
which is excluded from version control for security reasons. Instead, its value is securely stored in GitHub Secrets 
for this repository.

Additionally, the following variables are stored in GitHub:
- **`TERRAFORM_GITHUB_ACTIONS_ROLE_NAME`**: The name of the IAM role for GitHub Actions.
- **`TERRAFORM_VERSION`**: The specific version of Terraform to be used.
