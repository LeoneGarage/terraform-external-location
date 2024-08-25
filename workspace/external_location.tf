resource "databricks_external_location" "external" {
  name            = var.external_location_name
  url             = var.bucket_full_path
  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"

  depends_on = [ aws_iam_role.data_access_credential, databricks_storage_credential.external ]
}

resource "databricks_grants" "external_creds" {
  external_location = databricks_external_location.external.id
  grant {
    principal  = "account users"
    privileges = ["CREATE_EXTERNAL_TABLE", "CREATE_MANAGED_STORAGE", "READ_FILES", "WRITE FILES"]
  }
}