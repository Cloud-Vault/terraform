variable "access-key-id" {
    description = "AWS Account API Access Key ID"
    type = string

    validation {
        condition = (var.access-key-id != null)
        error_message = "Variable \"access-key-id\" is Required."
    }
}

variable "secret-access-key" {
    description = "AWS Account API Secret Access Token"
    type = string

    validation {
        condition = (var.secret-access-key != null)
        error_message = "Variable \"secret-access-token\" is Required."
    }
}
