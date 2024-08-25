terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.49.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  profile = var.aws_profile
}

provider "databricks" {
  host  = var.databricks_workspace_host
  token = var.databricks_workspace_token
}

output "databricks_host" {
  value = var.databricks_workspace_host
}
