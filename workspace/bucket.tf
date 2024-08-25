locals {
  path_splits = split("/", var.bucket_full_path)
  bucket_name = length(local.path_splits) > 1 ? local.path_splits[2] : ""
}

data "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
}
