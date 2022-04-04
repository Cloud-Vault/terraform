resource "aws_s3_bucket" "target" {
    provider = aws.target

    bucket = var.name
}

resource "aws_s3_bucket_acl" "target" {
    provider = aws.target

    bucket = aws_s3_bucket.target.id
    acl    = "private"
}

resource "aws_s3_bucket_versioning" "target" {
    provider = aws.target

    bucket = aws_s3_bucket.target.id

    versioning_configuration {
        status = (var.versioning == true) ? "Enabled" : "Disabled"
        mfa_delete = (var.mfa == true) ? "Enabled" : "Disabled"
    }
}

data "aws_caller_identity" "target" {
    provider = aws.target
}

locals {
    policy = (var.external-account == null) ? [
        jsonencode({
            "Version" : "2012-10-17",
            "Statement" : [
                {
                    "Sid" : "",
                    "Effect" : "Allow",
                    "Principal" : {
                        "AWS" : "arn:aws:iam::${data.aws_caller_identity.target.account_id}:root"
                    },
                    "Action" : "s3:*",
                    "Resource" : "arn:aws:s3:::${aws_s3_bucket_versioning.target.bucket}/*"
                }
            ]
        })
    ] : [
        jsonencode({
            "Version" : "2012-10-17",
            "Statement" : [
                {
                    "Sid" : "",
                    "Effect" : "Allow",
                    "Principal" : {
                        "AWS" : "arn:aws:iam::${data.aws_caller_identity.target.account_id}:root"
                    },
                    "Action" : "s3:*",
                    "Resource" : "arn:aws:s3:::${aws_s3_bucket_versioning.target.bucket}/*"
                }
            ]
        }),
        jsonencode({
            "Version" : "2012-10-17",
            "Statement" : [
                {
                    "Sid" : "",
                    "Effect" : "Allow",
                    "Principal" : {
                        "AWS" : "arn:aws:iam::${var.external-account}:root"
                    },
                    "Action" : "s3:*",
                    "Resource" : "arn:aws:s3:::${aws_s3_bucket_versioning.target.bucket}/*"
                }
            ]
        })
    ]
}

resource "aws_s3_bucket_policy" "target" {
    provider = aws.target

    count = length(local.policy)

    bucket = aws_s3_bucket.target.id
    policy = local.policy[count.index]
}
