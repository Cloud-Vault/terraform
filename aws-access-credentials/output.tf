output "credential" {
    value = module.self.credential
    description = "AWS Credential Object"
    sensitive = true
}
