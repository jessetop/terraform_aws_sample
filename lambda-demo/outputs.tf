output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.demo_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.demo_lambda.arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.demo_lambda.invoke_arn
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = var.create_api_gateway ? aws_api_gateway_deployment.demo_deployment[0].invoke_url : null
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}