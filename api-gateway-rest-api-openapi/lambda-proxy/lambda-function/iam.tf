/// Lambda Invocation Permissions -----------------------------------------------------------------

resource "aws_iam_role" "role" {
    name               = join("-", [ var.name, "STS-Role" ])
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }, {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "apigateway.amazonaws.com"
                }
            }
        ]
    })
}

/// Base Lambda Invocation Service-Role Association
resource "aws_iam_role_policy_attachment" "lambda-policy" {
    role       = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

/// API-Gateway Cloudwatch IAM Association
resource "aws_iam_role_policy_attachment" "api-gateway-cloudwatch-policy-attachment" {
    role       = aws_iam_role.role.name
    policy_arn = data.aws_iam_policy.api-gateway-cloudwatch-policy.arn
}

/// X-Ray AWS Managed Policy
data "aws_iam_policy" "xray-write-only-access-policy" {
    arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

/// X-Ray Policy Association
resource "aws_iam_role_policy_attachment" "xray-write-only-access-policy-attachment" {
    role       = aws_iam_role.role.name
    policy_arn = data.aws_iam_policy.xray-write-only-access-policy.arn
}

# define iam policy with logging permissions
resource "aws_iam_policy" "logging-policy" {
    name        = join("-", [ aws_iam_role.role.name, "Logging-Policy" ])
    description = "CloudWatch Logging Permissions"

    policy = data.aws_iam_policy_document.logging-policy-document.json
}

data "aws_iam_policy_document" "logging-policy-document" {
    statement {
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]

        effect = "Allow"

        resources = [ "arn:aws:logs:*:*:*" ]
    }
}

/// API-Gateway Cloudwatch AWS-Managed Policy
data "aws_iam_policy" "api-gateway-cloudwatch-policy" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_policy" "vpc-configuration-policy" {
    name        = join("-", [ aws_lambda_function.function.function_name, "VPC-Policy" ])
    description = "VPC Configuration Permissions"

    policy = data.aws_iam_policy_document.vpc-configuration-document.json
}

data "aws_iam_policy_document" "vpc-configuration-document" {
    statement {
        actions = [
            "ec2:DescribeNetworkInterfaces",
            "ec2:CreateNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeInstances",
            "ec2:AttachNetworkInterface"
        ]

        effect = "Allow"

        resources = [ "*" ]
    }
}

resource "aws_iam_policy_attachment" "logging-policy-association" {
    name       = join("-", [ aws_lambda_function.function.function_name, "Lambda-Association" ])
    roles      = [ aws_iam_role.role.id ]
    policy_arn = aws_iam_policy.logging-policy.arn
}

resource "aws_iam_policy_attachment" "vpc-configuration-policy-association" {
    name       = join("-", [ aws_lambda_function.function.function_name, "VPC-Association" ])
    roles      = [ aws_iam_role.role.id ]
    policy_arn = aws_iam_policy.vpc-configuration-policy.arn
}

resource "aws_iam_role_policy_attachment" "vpc-access-execution-role-attachment" {
    role       = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
