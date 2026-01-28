# Elastic Beanstalk Terraform Demo

This Terraform project demonstrates how to deploy an AWS Elastic Beanstalk application.

## What's Included

- Elastic Beanstalk Application
- Elastic Beanstalk Environment
- S3 bucket for application versions
- IAM roles and policies for Elastic Beanstalk service and EC2 instances

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

4. Clean up resources:
   ```bash
   terraform destroy
   ```

## Configuration

Edit `terraform.tfvars` to customize:
- AWS region
- Application name
- Environment name
- Instance type and scaling settings

## Notes

- The default configuration uses Python 3.11 platform
- Instances are configured with t3.micro (free tier eligible)
- Auto-scaling is configured with min 1, max 2 instances by default