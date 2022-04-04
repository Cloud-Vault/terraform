variable "name" {
    description = "Resource Endpoint Partition for Invocation of Lambda Function from API Gateway"
    type        = string
}

variable "normalization" {
    description = "Name Normalization for Cases when API +1 Methods & +1 Gateway Resources Execute the Same Lambda Function"
    type        = list(string)
    nullable    = true
    default     = null
}

variable "description" {
    description = "Lambda Function Description"
    type        = string
    default     = null
    nullable    = true
}

variable "timeout" {
    description = "Runtime Timeout (Seconds) - Defaults to 30 Seconds"
    type        = number
    default     = null
    nullable    = true
}

variable "memory-size" {
    description = "Runtime Memory Allocation (MB) - Defaults to 256"
    type        = number
    default     = null
    nullable    = true
}

variable "environment-variables" {
    description = "Runtime Environment Configuration"
    type        = map(string)
    default     = {
        NODE_ENV = "production"
    }
}

variable "vpc-configuration" {
    description = "Lambda Function VPC Connection Integration(s)"
    type        = object({
        security-group-identifiers = set(string)
        subnet-identifiers         = set(string)
    })

    default  = null
    nullable = true
}

variable "runtime" {
    description = "Runtime Language + Version"
    type        = string
    default     = null
    nullable    = true
}

variable "publish" {
    description = "Enable Lambda Version Publishing"
    type        = bool
    default     = null
    nullable    = true
}

variable "artifacts-bucket" {
    description = "AWS Lambda Function Artifacts S3 Bucket (S3 Bucket Name)"
    type        = string
    nullable    = false
}

variable "cors" {
    description = "Very Rare Edge Case for CORS Permission Enablement"
    type        = object({
        enable = bool
        source = optional(string)
    })

    default  = { enable = false }
    nullable = false
}

variable "execution-source" {
    description = "API Gateway Execute-API Invocation Source ARN for Lambda-Permission Resource(s)"
    type        = string /// list(string)
    nullable    = false
}

variable "account" {
    description = "API Gateway Execute-API Source AWS Account for Lambda-Permission Resource(s)"
    type        = string
    nullable    = false
}

variable "repository" {
    description = "(Optional) Tag for Identifying VCS Controlled Cloud Resource(s)"
    type        = string
    nullable    = true
    default     = null
}

variable "project-id" {
    description = "(Optional) Tag for Identifying VCS, CI-CD Project IDs"
    type        = number
    nullable    = true
    default     = null
}
