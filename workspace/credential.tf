locals {
  role_name        = var.role_name
  role_arn         = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.role_name}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "passrole_for_uc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.databricks_account_id]
    }
  }
  statement {
    sid     = "ExplicitSelfRoleAssumption"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = [local.role_arn]
    }
  }
}

resource "aws_iam_policy" "data_access_credential" {
  name = "${local.role_name}_policy"
  // Terraform's "jsonencode" function converts a
  // Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${local.role_name}"
    Statement = [
      {
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          data.aws_s3_bucket.bucket.arn,
          "${data.aws_s3_bucket.bucket.arn}/*"
        ],
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "sts:AssumeRole"
        ],
        "Resource" : [
          "${local.role_arn}"
        ],
        "Effect" : "Allow"
      },
    ]
  })
  tags = merge(var.tags, {
    Name = "unity-catalog credential IAM policy"
  })
}

resource "aws_iam_role" "data_access_credential" {
  name                = local.role_name
  assume_role_policy  = data.aws_iam_policy_document.passrole_for_uc.json
  managed_policy_arns = [aws_iam_policy.data_access_credential.arn]
  tags = merge(var.tags, {
    Name = "unity-catalog credential IAM role"
  })

  depends_on = [ aws_iam_policy.data_access_credential ]
}

resource "time_sleep" "wait" {
  depends_on = [
  aws_iam_role.data_access_credential,
  aws_iam_policy.data_access_credential]
  create_duration = "20s"
}
