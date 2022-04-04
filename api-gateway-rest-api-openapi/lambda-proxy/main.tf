// https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-settings-method-request.html#api-gateway-proxy-resource
/// Integration request data mapping expressions
/// Mapped data source 	Mapping expression
/// Method request path 	method.request.path.PARAM_NAME
/// Method request query string 	method.request.querystring.PARAM_NAME
/// Multi-value method request query string 	method.request.multivaluequerystring.PARAM_NAME
/// Method request header 	method.request.header.PARAM_NAME
/// Multi-value method request header 	method.request.multivalueheader.PARAM_NAME
/// Method request body 	method.request.body
/// Method request body (JsonPath) 	method.request.body.JSONPath_EXPRESSION.
/// Stage variables 	stageVariables.VARIABLE_NAME
/// Context variables 	context.VARIABLE_NAME that must be one of the supported context variables.
/// Static value 	'STATIC_VALUE'. The STATIC_VALUE is a string literal and must be enclosed within a pair of single quotes.

/// Method response header mapping expressions
/// Mapped data source 	Mapping expression
/// Integration response header 	integration.response.header.PARAM_NAME
/// Integration response header 	integration.response.multivalueheader.PARAM_NAME
/// Integration response body 	integration.response.body
/// Integration response body (JsonPath) 	integration.response.body.JSONPath_EXPRESSION
/// Stage variable 	stageVariables.VARIABLE_NAME
/// Context variable 	context.VARIABLE_NAME that must be one of the supported context variables.
/// Static value 	'STATIC_VALUE'. The STATIC_VALUE is a string literal and must be enclosed within a pair of single quotes.

/// Passthrough Behavior
/// https://docs.aws.amazon.com/apigateway/latest/developerguide/integration-passthrough-behaviors.html

/// Mapping Template https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
/// Example for Querystring
/// {
//    "name" : "$input.params('name')",
//    "body" : $input.json('$')
// }
/// Example for Body
/// {
//    "name" : "$input.params('name')",
//    "body" : $util.escapeJavaScript($input.json('$.mykey'))
//}

// Construct
// HTTP resource
// HTTP resource method
// HTTP resource method request parameters
// HTTP resource method request model
// HTTP resource method request authorization
// HTTP resource method request validation

/*
Use a proxy resource to streamline API setup

Valid
/{proxy+}
/parent/{proxy+}
/parent/{child}/{proxy+}

Invalid
/{proxy+}/child
/parent/{proxy+}/{child}
/parent/{child}/{proxy+}/{grandchild+}
*/

variable "method" {
    default = "GET"
}

variable "path" {
    default = "/api/v1/{dynamic}/static-path/{proxy+}"
}

/// Path parameters containing arrays and objects can be serialized in different ways:
/// - path-style expansion (matrix) – semicolon-prefixed, such as /map/point;x=50;y=20
/// - label expansion – dot-prefixed, such as /color.R=100.G=200.B=150
/// - simple-style – comma-delimited, such as /users/12,34,56

/// Query parameters can be primitive values, arrays and objects. OpenAPI 3.0 provides several ways to serialize objects and arrays in the query string.
///
/// Arrays can be serialized as:
/// - form – /products?color=blue,green,red or /products?color=blue&color=green, depending on the explode keyword
/// - spaceDelimited (same as collectionFormat: ssv in OpenAPI 2.0) – /products?color=blue%20green%20red
/// - pipeDelimited (same as collectionFormat: pipes in OpenAPI 2.0) – /products?color=blue|green|red
///
/// Objects can be serialized as:
/// - form – /points?color=R,100,G,200,B,150 or /points?R=100&G=200&B=150, depending on the explode keyword
/// - deepObject – /points?color[R]=100&color[G]=200&color[B]=150

/// uuid Example
/// in: header
//  name: X-Request-ID
//  schema:
//    type: string
//    format: uuid
//  required: true

variable "parameters" {
    default = [
        {
            in       = "path"
            description = "[... Parameter Description]"
            required = true
            name     = "proxy"
            schema   = {
                type = "string"
            }
        },
        {
            in       = "path"
            description = "[... Parameter Description]"
            required = true
            name     = "dynamic"
            schema   = {
                type = "string"
            }
        },

        /// >>> (No-Operation, Invalid) {
        /// >>> (No-Operation, Invalid)     in       = "path"
        /// >>> (No-Operation, Invalid)     required = true
        /// >>> (No-Operation, Invalid)     name     = "proxy"
        /// >>> (No-Operation, Invalid)     schema   = {
        /// >>> (No-Operation, Invalid)         type = "string"
        /// >>> (No-Operation, Invalid)     }
        /// >>> (No-Operation, Invalid) },
//        {
//            /// in       = "query"
//            in       = "query"
//            required = false
//            name     = "optional"
//            default = 1000
//            explode = false
//            example = 1
//            schema = {
//                type = "integer"
//                allowEmptyValue = true
//                nullable = true
//            }
//        },
        {
            in       = "query"
            description = "[... Parameter Description]"
            required = false
            name     = "example-query-parameter"
            default = "query-string-required-assignment"
            explode = false
            examples = {
                query-string-required-assignment-example = {
                    summary = "Example Documentation of Parameter Query"
                    value = "Hello-World"
                }
            }
            schema = {
                type = "string"
                allowEmptyValue = true
                nullable = true
            }
        },
        {
            in       = "header"
            description = "[... Parameter Description]"
            name     = "Authorization"
            required = false
            explode = false
            schema   = {
                type = "string"
                allowEmptyValue = true
                nullable = true
            }
        },
        {
            description = "Full Explanation -- Not Just Deprecation Notice"
            summary = "[Insert Deprecation Notice Here]"
            in       = "query"
            description = "[... Parameter Description]"
            name     = "example-deprecation-parameter"
            required = false
            explode = false
            deprecated = true
            default = "constant-deprecated-value"
            schema   = {
                type = "string"
                allowEmptyValue = true
            }
            enum = [
                "constant-deprecated-value"
            ]
        },
        {
            in     = "cookie"
            description = "[... Parameter Description]"
            name   = "debug"
            schema = {
                type = "integer"
            }
            enum    = [ 0, 1 ]
            default = 0
        },
        {
            in     = "cookie"
            description = "[... Parameter Description]"
            name   = "csrftoken"
            schema = {
                type = "string"
            }
            enum    = [ 0, 1 ]
            default = 0
        },
        {
            in       = "query"
            description = "[... Parameter Description]"
            name     = "status-enumeration"
            required = true
            explode = false
            default = null
            schema   = {
                type = "string"
                allowEmptyValue = false
                nullable = true
            }
            enum = [
                "available"    ,
                "initializing",
                "draining"    ,
                "offline"
            ]
        },
        {
            in       = "query"
            description = "[... Parameter Description]"
            name     = "example-constant"
            required = true
            explode = false
            schema   = {
                type = "string"
            }
            enum = [
                "constant-value"
            ]
        }
    ]
}

variable "cache-keys" {
    default = [
        /// "proxy",
        "example-constant",
        "path",
        /// "dynamic",
        "status-enumeration"
    ]
}

variable "request-body" {
    default = null
}

variable "security" {
    default = [ ]
}

variable "responses" {
    default = {
        302 = {
            description = "302 Response"
            headers     = {
                Access-Control-Allow-Origin = {
                    schema = {
                        type = "string"
                    }
                }
            }

            content = {}
        }
    }
}

variable "validator" {
    type = string

    /// default  = "Querystring-Body-Headers"
    default = "Validate query string parameters and headers"
    nullable = true

    /// validation {
    ///     condition     = (var.validator == "Querystring-Body-Headers" || var.validator == "Querystring-Headers" || var.validator == "Querystring-Body" || var.validator == "Body-Headers" || var.validator == "Headers" || var.validator == "Body" )
    ///     error_message = "Invalid Validator Type."
    /// }
}

variable "region" {
    default = "us-east-2"
}

/// aws sts get-caller-identity --query "Account" --output text
variable "account-id" {
    default = "700423713782"
}

variable "lambda-function" {
    default = "conceptual-proof-of-concept-logging-lambda"
}

variable "timeout" {
    default = 29000
}

variable "request-templates" {
    type = map(string)

    default = {
        "application/json" = "{ \"statusCode\": 200 }"
    }
}

variable "integration-responses" {
    type = map(any)

    description = "Response(s) for a Lambda Proxy HTTP Call"
    nullable    = true
    default     = {
        default = {
            statusCode = "200"
        }
    }
}

resource "aws_s3_bucket" "bucket" {
    bucket = lower(var.lambda-function)

    tags = {
        Resource-Type = "Lambda-Artifact-Storage"
    }
}

resource "aws_s3_bucket_acl" "access-control-list" {
    bucket = aws_s3_bucket.bucket.id
    acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3-bucket" {
    bucket = aws_s3_bucket.bucket.id

    versioning_configuration {
        status = "Enabled"
    }
}

module "lambda" {
    source = "./lambda-function"

    account          = var.account-id
    artifacts-bucket = aws_s3_bucket_versioning.s3-bucket.bucket
    execution-source = "${local.source-arn-prefix}/${var.method}/${trimprefix(var.path, "/")}"
    name             = var.lambda-function
}

locals {
    source-arn-prefix = "arn:aws:execute-api:${var.region}:${var.account-id}:${aws_api_gateway_rest_api.test.id}/*"

    method-normalization = lower(var.method)

    parameter-keys = [ for parameter, settings in var.parameters : lookup(var.parameters[ parameter ], "name", null) ]

    implementation = {
        parameters  = var.parameters
        responses   = (var.responses != null) ? var.responses : {}
        requestBody = (var.request-body != null) ? var.request-body : {
            headers = {
                X-API-Test-Token = {
                    schema = {
                        type = "string"
                    }
                }
            }

            content = {
                "application/json" = {
                    schema = {
                        type = "string"

                        /// "$ref" = "#/components/schemas/Default"
                    }
                }
            }
        }

        security    = (var.security != null) ? var.security : [ ]

        /// Theory - Globally Enabling the following section will default enforce validations
        /// However, if a given method specifically defines false for enablement, the request
        /// will still succeed without failure being due to validation
        ///
        /// Why would we do this?
        ///
        /// Because it's sometimes easier to enable everything at the global level, and
        /// then be explicit about derivative resources. This is a type of pattern found
        /// when the provider doesn't create easy, scalable ways for dynamic child
        /// configuration(s) generators to inherit that otherwise dependent value.

        /// Then, programmatic, type enforce can be easily referenced via a enumeration-type

        /// Open-API Type := x-amazon-apigateway-request-validators

        /// (Example Global Definition ) x-amazon-apigateway-request-validators = {
        /// (Example Global Definition )     "Query-String-Body-Headers" = {
        /// (Example Global Definition )         validateRequestParameters = true
        /// (Example Global Definition )         validateRequestBody       = true
        /// (Example Global Definition )         validateRequestHeaders = true
        /// (Example Global Definition )     }
        /// (Example Global Definition )
        /// (Example Global Definition )     "Query-String-Headers" = {
        /// (Example Global Definition )         validateRequestParameters = true
        /// (Example Global Definition )         validateRequestHeaders = true
        /// (Example Global Definition )     }
        /// (Example Global Definition )
        /// (Example Global Definition )     "Query-String" = {
        /// (Example Global Definition )         validateRequestParameters = true
        /// (Example Global Definition )     }
        /// (Example Global Definition ) }

        x-amazon-apigateway-any-method : {
            parameters : [
                {
                    "name" : "proxy",
                    "in" : "path",
                    "required" : true,
                    "type" : "string"
                }
            ]
        }

        x-amazon-apigateway-request-validator = var.validator
        x-amazon-apigateway-integration       = {
            type : "aws_proxy"
            passthroughBehavior : "when_no_match"
            httpMethod = "POST"
            uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.account-id}:function:${var.lambda-function}/invocations"
            /// uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.account-id}:function:post_book_filter_metadata_staging/invocations"
            contentHandling : "CONVERT_TO_TEXT"

            cacheKeyParameters = [
            for parameter, index in local.parameter-keys : join(".", [
                "method",
                "request",
                lookup(var.parameters[ parameter ], "in", ""),
                lookup(var.parameters[ parameter ], "name", "")
            ]) if can(index(var.cache-keys, lookup(var.parameters[ parameter ], "name", ""))) && lookup(var.parameters[ parameter ], "in", "") == "path"
            ]

            credentials = null // module.lambda.permissions /// "arn:aws:iam::${var.account-id}:role/${module.lambda.role}"

            timeoutInMillis : var.timeout
            /// default to 29000

            requestTemplates = var.request-templates

            responseTemplates = {}

            "responses" = {
                default = {
                    statusCode         = "200"
                    ///  responseParameters = {
                    ///      "method.response.header.error_trace_function" = "integration.response.body.errorMessage.trace.function"
                    ///      "method.response.header.error_status"         = "integration.response.body.errorMessage.httpStatus"
                    ///      "method.response.header.error_type"           = "integration.response.body.errorMessage.errorType"
                    ///      "method.response.header.error_trace"          = "integration.response.body.errorMessage.trace"
                    ///  }
                }
            }

            /// requestParameters = {
            /// for parameter, settings in var.parameters : join(".", [
            ///     "integration",
            ///     "request",
            ///     lookup(settings, "in", ""),
            ///     lookup(settings, "name", ""),
            /// ]) => join(".", [
            ///     "method",
            ///     "request",
            ///     lookup(settings, "in", ""),
            ///     lookup(settings, "name", "")
            /// ]) /// if lookup(settings, "in", null) != null && lookup(settings, "in", null) != "querystring"
            /// }
        }

        # (11 unchanged elements hidden)

        /*
        Gateway response type 	Default status code 	Description
        ACCESS_DENIED - 403 - The gateway response for authorization failure—for example, when access is denied by a custom or Amazon Cognito authorizer. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        API_CONFIGURATION_ERROR - 500 - The gateway response for an invalid API configuration—including when an invalid endpoint address is submitted, when base64 decoding fails on binary data when binary support is enacted, or when integration response mapping can't match any template and no default template is configured. If the response type is unspecified, this response defaults to the DEFAULT_5XX type.
        AUTHORIZER_CONFIGURATION_ERROR - 500 - The gateway response for failing to connect to a custom or Amazon Cognito authorizer. If the response type is unspecified, this response defaults to the DEFAULT_5XX type.
        AUTHORIZER_FAILURE - 500 - The gateway response when a custom or Amazon Cognito authorizer failed to authenticate the caller. If the response type is unspecified, this response defaults to the DEFAULT_5XX type.
        BAD_REQUEST_PARAMETERS - 400 - The gateway response when the request parameter cannot be validated according to an enabled request validator. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        BAD_REQUEST_BODY - 400 - The gateway response when the request body cannot be validated according to an enabled request validator. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        DEFAULT_5XX - Null - The default gateway response for an unspecified response type with a status code of 5XX. Changing the status code of this fallback gateway response changes the status codes of all other 5XX responses to the new value. Resetting this status code to null reverts the status codes of all other 5XX responses to their original values.
        EXPIRED_TOKEN - 403 - The gateway response for an AWS authentication token expired error. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        INTEGRATION_FAILURE - 504 - The gateway response for an integration failed error. If the response type is unspecified, this response defaults to the DEFAULT_5XX type.
        INTEGRATION_TIMEOUT - 504 - The gateway response for an integration timed out error. If the response type is unspecified, this response defaults to the DEFAULT_5XX type.
        INVALID_API_KEY - 403 - The gateway response for an invalid API key submitted for a method requiring an API key. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        INVALID_SIGNATURE - 403 - The gateway response for an invalid AWS signature error. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        MISSING_AUTHENTICATION_TOKEN - 403 - The gateway response for a missing authentication token error, including the cases when the client attempts to invoke an unsupported API method or resource. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        QUOTA_EXCEEDED - 429 - The gateway response for the usage plan quota exceeded error. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        REQUEST_TOO_LARGE - 413 - The gateway response for the request too large error. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        RESOURCE_NOT_FOUND - 404 - The gateway response when API Gateway cannot find the specified resource after an API request passes authentication and authorization, except for API key authentication and authorization. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        THROTTLED - 429 - The gateway response when usage plan-, method-, stage-, or account-level throttling limits exceeded. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        UNAUTHORIZED - 401 - The gateway response when the custom or Amazon Cognito authorizer failed to authenticate the caller.
        UNSUPPORTED_MEDIA_TYPE - 415 - The gateway response when a payload is of an unsupported media type, if strict passthrough behavior is enabled. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.
        WAF_FILTERED - 403 - The gateway response when a request is blocked by AWS WAF. If the response type is unspecified, this response defaults to the DEFAULT_4XX type.

        */

        //        x-amazon-apigateway-gateway-responses = {
        //            INTERNAL_SERVER_ERROR = {
        //                statusCode         = 500
        //                responseParameters = {
        //                    "gatewayresponse.header.x-request-path"              = "method.input.params.petId",
        //                    "gatewayresponse.header.x-request-query"             = "method.input.params.q",
        //                    "gatewayresponse.header.Access-Control-Allow-Origin" = "'a.b.c'",
        //                    "gatewayresponse.header.x-request-header"            = "method.input.params.Accept"
        //                }
        //
        //                responseTemplates = {
        //                    "application/json" = "{ errorMessage: $input.path('$.errorMessage') }"
        //                }
        //            }
        //
        //            MISSING_AUTHENTICATION_TOKEN = {
        //                statusCode         = 404
        //                responseParameters = {
        //                    "gatewayresponse.header.x-request-path"              = "method.input.params.petId",
        //                    "gatewayresponse.header.x-request-query"             = "method.input.params.q",
        //                    "gatewayresponse.header.Access-Control-Allow-Origin" = "'a.b.c'",
        //                    "gatewayresponse.header.x-request-header"            = "method.input.params.Accept"
        //                }
        //
        //                responseTemplates = {
        //                    "application/json" = "{\n     \"message\": $context.error.messageString,\n     \"type\":  \"$context.error.responseType\",\n     \"stage\":  \"$context.stage\",\n     \"resourcePath\":  \"$context.resourcePath\",\n     \"stageVariables.a\":  \"$stageVariables.a\",\n     \"statusCode\": \"'404'\"\n}"
        //                }
        //            }
        //        }
        //    }

    }

    paths = {
        /// Suggestion: Enforce lower-case path partitions
        (var.path) = {
            (local.method-normalization) = local.implementation
            /// HTTP EXAMPLE (NOT LAMBDA PROXY) x-amazon-apigateway-integration = {
            /// HTTP EXAMPLE (NOT LAMBDA PROXY)     httpMethod           = "GET"
            /// HTTP EXAMPLE (NOT LAMBDA PROXY)     payloadFormatVersion = "1.0"
            /// HTTP EXAMPLE (NOT LAMBDA PROXY)     type                 = "HTTP_PROXY"
            /// HTTP EXAMPLE (NOT LAMBDA PROXY)     uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
            /// HTTP EXAMPLE (NOT LAMBDA PROXY) }
        }
    }
}

provider "aws" {
    shared_config_files      = [ "~/.aws/config" ]
    shared_credentials_files = [ "~/.aws/credentials" ]
    profile                  = "default"
    region                   = var.region

    skip_metadata_api_check = false
}

output "open-api" {
    value = local.paths
}

resource "aws_api_gateway_rest_api" "test" {
    name = "test-open-api-rest-gateway"
    body = jsonencode({
        openapi = "3.0.1"

        info = {
            title   = "arbitrary-name"
            version = "1.0"
        }

        paths = local.paths

        securitySchemes = {
            global-authorizer = {
                type                           = "apiKey"
                name                           = "Authorization"
                in                             = "header"
                x-amazon-apigateway-authtype   = "custom"
                x-amazon-apigateway-authorizer = {
                    type                         = "token"
                    authorizerUri                = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:700423713782:function:lambda_authorizer_generic_qa/invocations"
                    authorizerResultTtlInSeconds = 0
                    identityValidationExpression = "^Bearer [-0-9a-zA-z.]*$"
                }
            }
        }

        x-amazon-apigateway-request-validators = {
            "Validate query string parameters and headers" = {
                validateRequestParameters = false
                validateRequestBody       = false
            }
        }
    })
}

resource "aws_api_gateway_deployment" "default" {
    rest_api_id = aws_api_gateway_rest_api.test.id

    description       = "The Service's Currently Active Stage"
    stage_description = "Primary, Active Stage"

    triggers = {
        redeployment = sha1(jsonencode([
            aws_api_gateway_rest_api.test.body
        ]))

        /// force-deployment = (var.force-deployment == true) ? timestamp() : null
    }

    depends_on = [ aws_api_gateway_rest_api.test ]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_api_gateway_stage" "example" {
    rest_api_id   = aws_api_gateway_rest_api.test.id
    deployment_id = aws_api_gateway_deployment.default.id

    stage_name           = "development" /// lower(var.environment)
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
    rest_api_id = aws_api_gateway_rest_api.test.id
    stage_name  = aws_api_gateway_stage.example.stage_name
    method_path = "*/*"

    settings {
        metrics_enabled = true
    }
}

//resource "null_resource" "whatever" {
//    triggers = {
//        trigger = timestamp()
//    }
//
//    provisioner "local-exec" {
//        command = "secrets-manager --list > output-example.json"
//    }
//}

// resource "aws_api_gateway_documentation_part" "test" {
//     properties  = aws_api_gateway_rest_api.test.body
//     rest_api_id = aws_api_gateway_rest_api.test.id
//     location {
//         type = "json"
//     }
// }
