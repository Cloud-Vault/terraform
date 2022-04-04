variable "namespace" {
    description = "Global Prefix, Namespace"
    type        = string
    nullable    = false
}

variable "profile" {
    description = "Target Cloud Profile"
    type        = string
    default     = "default"
    nullable    = false
}

variable "application" {
    description = "Application Name"
    type        = string
    nullable    = false
}

variable "service" {
    description = "Application's Service Name"
    type        = string
    nullable    = false
}

variable "deployment-version" {
    description = "API Gateway + Documentation + Service(s) Semantic Version"
    type        = string
    default     = "0.0.0"
    nullable    = false
}

variable "zone" {
    description = "Target Base Domain Name, AWS Route-53 Zone"
    type        = string
    nullable    = false
}

variable "subdomain" {
    description = "Target Subdomain"
    type        = string
    nullable    = false
}

variable "overwrite-dns-records" {
    description = "A Boolean that Will Overwrite Already Established DNS Records if Record(s) Exist"
    type        = bool
    default     = false
    nullable    = true
}

variable "region" {
    default     = "us-west-2"
    description = "AWS Region for API Gateway REST API Deployment"
    type        = string
}

variable "force-deployment" {
    description = "Force API Gateway Stage Deployment"
    type        = bool
    default     = false
    nullable    = true
}

variable "name" {
    default     = "api-gateway-rest-api-openapi-example"
    description = "Name of the API Gateway REST API"
    type        = string
}

variable "description" {
    description = "The Description of the API Gateway Service"
    type        = string
    default     = null
    nullable    = true
}

variable "domain-name" {
    default     = "example.com"
    description = "Domain name of the API Gateway REST API for self-signed TLS certificate"
    type        = string
}

variable "disable-default-domain" {
    description = "Disable the Default API Gateway FQDN"
    default = false
    type = bool
}

variable "rest_api_path" {
    default     = "/path1"
    description = "Path to create in the API Gateway REST API (can be used to trigger redeployments)"
    type        = string
}

variable "environment" {
    description = "Target Cloud Environment"
    type        = string
    nullable    = false
    default     = "Development"

    validation {
        condition = (var.environment == "Development" && var.environment == "QA" && var.environment == "Staging" && var.environment == "UAT" && var.environment == "Production")
        error_message = "Invalid Environment Name."
    }
}
