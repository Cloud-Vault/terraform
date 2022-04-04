resource "aws_api_gateway_rest_api" "example" {
    body = jsonencode({
        openapi = "3.0.1"

        info    = {
            title   = var.name
            version = "1.0"
        }

        paths = {
            (var.rest_api_path) = {
                get = {
                    x-amazon-apigateway-integration = {
                        httpMethod           = "GET"
                        payloadFormatVersion = "1.0"
                        type                 = "HTTP_PROXY"
                        uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
                    }
                }
            }
        }
    })

    name = var.name

    description                  = (var.description != null) ? var.description : "API Gateway Service"
    disable_execute_api_endpoint = false

    endpoint_configuration {
        types = [
            "EDGE"
        ]
    }
}

resource "aws_api_gateway_deployment" "example" {
    rest_api_id = aws_api_gateway_rest_api.example.id

    description       = "The Service's Currently Active Stage"
    stage_description = "${var.environment} - Environment Specific Stage"

    triggers = {
        redeployment = sha1(jsonencode([
            aws_api_gateway_rest_api.example
        ]))

        force-deployment = (var.force-deployment == true) ? timestamp() : null
    }

    lifecycle {
        create_before_destroy = true
    }
}
