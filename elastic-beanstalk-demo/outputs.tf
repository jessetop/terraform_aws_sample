output "application_name" {
  description = "Name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.app.name
}

output "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.env.name
}

output "environment_url" {
  description = "URL of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.env.endpoint_url
}

output "s3_bucket" {
  description = "S3 bucket for application versions"
  value       = aws_s3_bucket.eb_bucket.bucket
}

output "solution_stack_name" {
  description = "Solution stack name used for the environment"
  value       = data.aws_elastic_beanstalk_solution_stack.python.name
}