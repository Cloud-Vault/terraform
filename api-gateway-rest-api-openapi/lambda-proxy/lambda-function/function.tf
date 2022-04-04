/// Lambda Function ----------

# Archive - Although the following namespace belongs to a `data` type,
# such will still create a new "resource", where the resource is a zip
# file of the source path(s).
data "archive_file" "lambda-function-artifact" {
    type        = "zip"
    source_dir  = join("/", [ path.module, "src" ])
    output_path = join("/", [ path.module, ".artifacts", join(".", [ lower(replace(var.name, " ", "-")), "zip" ]) ])
}

resource "aws_s3_object" "artifacts" {
    bucket = var.artifacts-bucket
    key    = filebase64sha512(data.archive_file.lambda-function-artifact.output_path)
    source = data.archive_file.lambda-function-artifact.output_path
}

resource "aws_lambda_function" "function" {
    function_name = var.name
    filename      = data.archive_file.lambda-function-artifact.output_path
    description   = (var.description != null) ? var.description : "[Description ...]"
    memory_size   = (var.memory-size != null) ? var.memory-size : 256
    package_type  = "Zip"
    runtime       = (var.runtime != null) ? var.runtime : "nodejs14.x"
    publish       = (var.publish != null) ? var.publish : true
    role          = aws_iam_role.role.arn
    handler       = "index.handler"
    timeout       = (var.timeout != null) ? var.timeout : 30

    layers = []

    vpc_config {
        security_group_ids = (var.vpc-configuration != null) ? try(var.vpc-configuration.security-group-identifiers) : [ ]
        subnet_ids         = (var.vpc-configuration != null) ? try(var.vpc-configuration.subnet-identifiers) : [ ]
    }

    tracing_config {
        mode = "Active"
    }

    environment {
        variables = var.environment-variables
    }

    lifecycle {
        ignore_changes = [
            role,
            environment,
            source_code_hash,
            source_code_size,
            last_modified,
            layers,
            publish
        ]
    }

    tags = {
        Repository = (var.repository != null) ? var.repository : "N/A"
        Project-ID = (var.project-id != null) ? tostring(var.project-id) : "N/A"
        Resource-Type = "Lambda-Function"
        VPC-Access = (var.vpc-configuration != null) ? "True" : "False"
    }
}

// resource "aws_lambda_alias" "alias" {
//     function_name    = aws_lambda_function.function.function_name
//     function_version = "$LATEST"
//
//     name             = (var.normalization != null) ? var.normalization[count.index] : "Alias-${aws_lambda_function.function.function_name}"
// }

resource "aws_lambda_permission" "lambda-invocation-permissions" {
    function_name = substr(aws_lambda_function.function.function_name, 0, 139)

    source_arn = var.execution-source
    source_account = var.account

    statement_id = "API-Gateway"
    action       = "lambda:InvokeFunction"
    principal    = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "lambda-invocation-permissions-cors" {
    count = (lookup(var.cors, "enable", false) == true) ? 1 : 0
    function_name = aws_lambda_function.function.function_name

    source_arn = var.cors.source
    source_account = var.account

    statement_id = "Allow-API-Gateway-Lambda-Execution-CORS"
    action       = "lambda:InvokeFunction"
    principal    = "apigateway.amazonaws.com"
}
