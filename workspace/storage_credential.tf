resource "databricks_storage_credential" "external" {
  name = aws_iam_role.data_access_credential.name
  aws_iam_role {
    role_arn = aws_iam_role.data_access_credential.arn
  }
  comment = "Managed by TF"

  depends_on = [ time_sleep.wait, aws_iam_role.data_access_credential ]
}
