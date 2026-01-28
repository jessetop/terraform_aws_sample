# Lambda Demo
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create a zip file for the Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

# Lambda function
resource "aws_lambda_function" "demo_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.function_name
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = var.runtime
  timeout         = var.timeout

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  tags = {
    Name        = var.function_name
    Environment = var.environment
  }
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
}

# API Gateway (optional)
resource "aws_api_gateway_rest_api" "demo_api" {
  count = var.create_api_gateway ? 1 : 0
  name  = "${var.function_name}-api"
}

resource "aws_api_gateway_resource" "demo_resource" {
  count       = var.create_api_gateway ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.demo_api[0].id
  parent_id   = aws_api_gateway_rest_api.demo_api[0].root_resource_id
  path_part   = "demo"
}

resource "aws_api_gateway_method" "demo_method" {
  count         = var.create_api_gateway ? 1 : 0
  rest_api_id   = aws_api_gateway_rest_api.demo_api[0].id
  resource_id   = aws_api_gateway_resource.demo_resource[0].id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  count                   = var.create_api_gateway ? 1 : 0
  rest_api_id             = aws_api_gateway_rest_api.demo_api[0].id
  resource_id             = aws_api_gateway_resource.demo_resource[0].id
  http_method             = aws_api_gateway_method.demo_method[0].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.demo_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "demo_deployment" {
  count       = var.create_api_gateway ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.demo_api[0].id
  stage_name  = var.environment

  depends_on = [
    aws_api_gateway_method.demo_method,
    aws_api_gateway_integration.lambda_integration
  ]
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gateway_invoke" {
  count         = var.create_api_gateway ? 1 : 0
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.demo_api[0].execution_arn}/*/*"
}