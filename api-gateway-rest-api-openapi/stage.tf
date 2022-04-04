#
# Stage and Stage Settings
#

resource "aws_api_gateway_stage" "example" {
    rest_api_id   = aws_api_gateway_rest_api.example.id
    deployment_id = aws_api_gateway_deployment.example.id

    stage_name           = lower(var.environment)
    xray_tracing_enabled = true

    description = "The Service's Default Stage"

    /// canary_settings {
    ///     percent_traffic          = null /// 0
    ///     stage_variable_overrides = null /// {}
    ///     use_stage_cache          = null /// false
    /// }

    /// dynamic "access_log_settings" {
    ///     for_each = try(aws_cloudwatch_log_group.function[*])
    ///     iterator = resource
    ///
    ///     content {
    ///         format = can(resource.value["arn"]) ? jsonencode({
    ///             requestId               = "$context.requestId"
    ///             sourceIp                = "$context.identity.sourceIp"
    ///             requestTime             = "$context.requestTime"
    ///             protocol                = "$context.protocol"
    ///             httpMethod              = "$context.httpMethod"
    ///             resourcePath            = "$context.resourcePath"
    ///             routeKey                = "$context.routeKey"
    ///             status                  = "$context.status"
    ///             responseLength          = "$context.responseLength"
    ///             integrationErrorMessage = "$context.integrationErrorMessage"
    ///         }) : null
    ///
    ///         destination_arn = can(resource.value["arn"]) ? resource.value["arn"] : null
    ///     }
    /// }
}

resource "aws_api_gateway_method_settings" "example" {
    rest_api_id = aws_api_gateway_rest_api.example.id
    stage_name  = aws_api_gateway_stage.example.stage_name
    method_path = "*/*"

    settings {
        metrics_enabled = true
    }
}
