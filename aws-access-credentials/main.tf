//variable "production" {
//    description = "Production AWS Account Credentials"
//    type = map(object({
//        # AWS Account API Access Key ID
//        access-key-id = string
//        # AWS Account Secret Access Key (Token)
//        secret-access-key = string
//    }))
//
//    nullable = false
//
//    validation {
//        condition = (var.production != null)
//        error_message = "Production AWS Credentials are Required."
//    }
//}
//
//variable "development" {
//    description = "Development AWS Account Credentials"
//    type = map(object({
//        # AWS Account API Access Key ID
//        access-key-id = string
//        # AWS Account Secret Access Key (Token)
//        secret-access-key = string
//    }))
//
//    nullable = false
//
//    validation {
//        condition = (var.development != null)
//        error_message = "Production AWS Credentials are Required."
//    }
//}

module "self" {
    source = "./modules/credential"

    access-key-id     = var.access-key-id
    secret-access-key = var.secret-access-key
}
