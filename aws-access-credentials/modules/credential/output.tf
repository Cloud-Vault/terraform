output "credential" {
    description = "AWS Credential Object"
    sensitive = true
    value = {
        access-key-id = var.access-key-id
        secret-access-key = var.secret-access-key
    }
}
