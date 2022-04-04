locals {
    /// [subdomain].[environment].[hosted-zone]
    domain = lower(join(".", [ var.subdomain, var.environment, var.zone ]))

    /// Normalized Environment Subdomain
    subdomain = lower(join(".", [ var.subdomain, var.environment ]))

}
