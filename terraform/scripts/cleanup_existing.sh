#!/bin/bash
# Cleanup script to destroy existing resources before fresh deployment

echo "🧹 Cleaning up existing AWS resources..."

# Set AWS region
export AWS_REGION=us-east-1

# Delete existing resources if they exist
echo "Checking for existing resources..."

# Delete Budget
aws budgets delete-budget \
  --account-id $(aws sts get-caller-identity --query Account --output text) \
  --budget-name monthly-free-tier-budget 2>/dev/null || echo "Budget not found or already deleted"

# Delete IAM instance profile and role
aws iam remove-role-from-instance-profile \
  --instance-profile-name dev-ec2-profile \
  --role-name dev-ec2-role 2>/dev/null || echo "Instance profile association not found"

aws iam delete-instance-profile \
  --instance-profile-name dev-ec2-profile 2>/dev/null || echo "Instance profile not found"

aws iam detach-role-policy \
  --role-name dev-ec2-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore 2>/dev/null || echo "Policy not attached"

aws iam delete-role \
  --role-name dev-ec2-role 2>/dev/null || echo "IAM role not found"

# Empty and delete S3 bucket
BUCKET_NAME="finops-logs-123456789012-dev"
aws s3 rm s3://${BUCKET_NAME} --recursive 2>/dev/null || echo "S3 bucket empty or not found"
aws s3api delete-bucket --bucket ${BUCKET_NAME} 2>/dev/null || echo "S3 bucket not found"

echo "✅ Cleanup completed. You can now run 'terraform apply' fresh."
