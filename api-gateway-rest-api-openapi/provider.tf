terraform {
    required_providers {
        aws = "~> 4.8"
    }
}

provider "aws" {
    shared_config_files      = [ "~/.aws/config" ]
    shared_credentials_files = [ "~/.aws/credentials" ]
    profile                  = var.profile
    region = var.region

    skip_metadata_api_check = false
}

provider "aws" {
    region = "us-east-1"

    alias = "acm-validation"

    shared_config_files      = [ "~/.aws/config" ]
    shared_credentials_files = [ "~/.aws/credentials" ]
    profile                  = "default"

    skip_metadata_api_check = false
}

provider "aws" {
    region = var.region

    alias                    = "production"
    shared_config_files      = [ "~/.aws/config" ]
    shared_credentials_files = [ "~/.aws/credentials" ]

    profile                  = "Production"

    skip_metadata_api_check = false
}
