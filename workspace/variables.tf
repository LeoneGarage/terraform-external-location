variable "databricks_account_id" {
  type = string
  sensitive = true
}

variable "databricks_workspace_host" {
  type = string
}
variable "databricks_workspace_token" {
  type = string
  sensitive = true
}

variable "bucket_full_path" {
  type = string
  default = "s3://demo2-leone/test"
}

variable "role_name" {
  type = string
  default = "leone-test"
}

variable "external_location_name" {
  type = string
  default = "demo2-leone-test"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "aws_profile" {
  default = ""
}

variable "region" {
  default = ""
}

variable "workspace" {
  default = ""
}

variable "tags" {
  default = {}
}
