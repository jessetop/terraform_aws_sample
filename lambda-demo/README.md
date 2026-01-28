# Lambda Terraform Demo

This Terraform project demonstrates how to deploy an AWS Lambda function with optional API Gateway integration.

## What's Included

- Lambda function with Python runtime
- IAM role and policies for Lambda execution
- CloudWatch log group for function logs
- Optional API Gateway REST API with POST endpoint
- Sample Python function code

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Test the Lambda function:
   ```bash
   aws lambda invoke --function-name my-demo-lambda --payload '{"test": "data"}' response.json
   ```

5. Clean up resources:
   ```bash
   terraform destroy
   ```

## Configuration

Edit `terraform.tfvars` to customize:
- AWS region
- Function name
- Runtime version
- Timeout settings
- API Gateway creation

## API Gateway

If `create_api_gateway` is set to `true`, the deployment will create:
- REST API with a `/demo` endpoint
- POST method that triggers the Lambda function
- The API URL will be output after deployment

## Function Code

The sample Lambda function in `lambda_function.py`:
- Handles both direct invocation and API Gateway events
- Returns JSON responses
- Logs incoming events to CloudWatch
- Uses environment variables