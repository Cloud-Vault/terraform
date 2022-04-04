terraform {
    required_version = ">= 1"
    required_providers {
        aws = "~> 4.8"
    }
}

provider "aws" {
    alias = "production"
    profile = try("Production")

    region     = var.production-target-region
    access_key = var.production-access-key-id
    secret_key = var.production-secret-access-key
}

provider "aws" {
    alias = "development"
    profile = can("default") ? "default" : "Development"

    region     = var.production-target-region
    access_key = var.production-access-key-id
    secret_key = var.production-secret-access-key
}

data "aws_caller_identity" "production" {
    provider = aws.production
}

module "s3-bucket" {
    source = "../.."

    name = var.name
    external-account = data.aws_caller_identity.production.account_id

    providers = {
        aws.target = aws.production
    }
}
