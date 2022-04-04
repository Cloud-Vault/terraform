variable "production-access-key-id" {
    description = "AWS Account API Access Key ID"
    type        = string
    nullable    = true
    default     = null
}

variable "production-secret-access-key" {
    description = "AWS Account API Secret Access Token"
    type        = string
    nullable    = true
    default     = null
}

variable "production-target-region" {
    description = "Target Deployment Region"
    type        = string
    nullable    = true
    default     = null
}

variable "development-access-key-id" {
    description = "AWS Account API Access Key ID"
    type        = string
    nullable    = true
    default     = null
}

variable "development-secret-access-key" {
    description = "AWS Account API Secret Access Token"
    type        = string
    nullable    = true
    default     = null
}

variable "development-target-region" {
    description = "Target Deployment Region"
    type        = string
    nullable    = true
    default     = null
}

variable "target-environment" {
    description = "Target AWS Deployment Account"
    type = string
    nullable = false
    default = "production"

    validation {
        condition = var.target-environment == "production" || var.target-environment == "default"
        error_message = "Target Environment Must be \"production\" || \"default\"."
    }
}

variable "name" {}
