# project-root/backend.tf

# Defines the S3 backend for Terraform state management.
# This ensures your state is stored remotely, enabling team collaboration and CI/CD.
terraform {
  backend "s3" {
    bucket         = "redshift-data-migration-bucket" # Your specified S3 bucket name
    key            = "grafana/grafana-stack.tfstate" # Path to the state file within the bucket
    region         = "us-east-1"                      # AWS region for the S3 bucket and DynamoDB table
    encrypt        = true                             # Encrypts the state file at rest in S3
    dynamodb_table = "rajeshso-grafana-tf-lock"       # DynamoDB table for state locking, preventing concurrent deployments
  }
}