variable "name" {
    description = "S3 Bucket Name"
    type = string
    nullable = false
}

variable "versioning" {
    description = "S3 Bucket Versioning"
    type = bool
    nullable = true
    default = true
}

variable "mfa" {
    description = "Enforce MFA for Object Deletion + S3 Bucket Management"
    type = bool
    nullable = true
    default = false
}

variable "external-account" {
    description = "External AWS Account ID for Cross-Account Enablement"
    type = string
    nullable = true
    default = null

    validation {
        condition = (var.external-account == null) || (var.external-account != "")
        error_message = "External Account ID Cannot := \"\"."
    }
}
