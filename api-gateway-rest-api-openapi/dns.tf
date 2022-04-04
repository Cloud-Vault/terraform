data "aws_route53_zone" "zone" {
    provider = aws.production
    name     = var.zone
}

resource "aws_route53_record" "subdomain-route-ipv4" {
    provider = aws.production

    allow_overwrite = var.overwrite-dns-records

    zone_id = data.aws_route53_zone.zone.id
    name    = local.subdomain
    type    = "A"

    alias {
        name                   = aws_api_gateway_domain_name.example.cloudfront_domain_name
        zone_id                = aws_api_gateway_domain_name.example.cloudfront_zone_id
        evaluate_target_health = true
    }
}

resource "aws_route53_record" "subdomain-route-ipv6" {
    provider = aws.production

    allow_overwrite = var.overwrite-dns-records

    zone_id = data.aws_route53_zone.zone.id
    name    = local.subdomain
    type    = "AAAA"

    alias {
        name                   = aws_api_gateway_domain_name.example.cloudfront_domain_name
        zone_id                = aws_api_gateway_domain_name.example.cloudfront_zone_id
        evaluate_target_health = true
    }
}

resource "aws_route53_record" "subdomain-route-www" {
    provider = aws.production

    allow_overwrite = var.overwrite-dns-records

    zone_id = data.aws_route53_zone.zone.id
    name    = join(".", [ "www", local.domain ])
    type    = "CNAME"
    ttl     = "60"

    records = [
        lower(aws_route53_record.subdomain-route-ipv4.fqdn)
    ]
}

resource "aws_acm_certificate" "certificate" {
    provider = aws.acm-validation

    validation_method = "DNS"
    domain_name       = local.domain
}

resource "aws_route53_record" "certificate-validations" {
    provider = aws.production

    for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
        name   = dvo.resource_record_name
        record = dvo.resource_record_value
        type   = dvo.resource_record_type
    } }

    allow_overwrite = true
    name            = each.value[ "name" ]
    records         = [ each.value[ "record" ] ]
    ttl             = 60
    type            = each.value[ "type" ]
    zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "validation" {
    provider = aws.acm-validation
    certificate_arn = aws_acm_certificate.certificate.arn

    timeouts {
        create = "120m"
    }
}
