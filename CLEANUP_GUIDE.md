# AWS Resource Cleanup Guide

This guide helps you clean up existing AWS resources that conflict with Terraform deployment.

## Option 1: Using AWS Console (Recommended for beginners)

### 1. Delete the Budget
1. Go to AWS Console → Billing → Budgets
2. Find "monthly-free-tier-budget"
3. Click Delete

### 2. Delete IAM Role
1. Go to AWS Console → IAM → Roles
2. Search for "dev-ec2-role"
3. Delete the role (it will automatically detach policies)

### 3. Delete S3 Bucket
1. Go to AWS Console → S3
2. Find bucket "finops-logs-123456789012-dev"
3. Empty the bucket first, then delete it

## Option 2: Using AWS CLI (Faster)

Run these commands in order:

```bash
# Get your AWS Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Delete Budget
aws budgets delete-budget \
  --account-id $ACCOUNT_ID \
  --budget-name monthly-free-tier-budget

# Delete IAM resources
aws iam remove-role-from-instance-profile \
  --instance-profile-name dev-ec2-profile \
  --role-name dev-ec2-role

aws iam delete-instance-profile \
  --instance-profile-name dev-ec2-profile

aws iam detach-role-policy \
  --role-name dev-ec2-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore

aws iam delete-role --role-name dev-ec2-role

# Delete S3 Bucket
BUCKET_NAME="finops-logs-123456789012-dev"
aws s3 rm s3://${BUCKET_NAME} --recursive
aws s3api delete-bucket --bucket ${BUCKET_NAME}
```

## After Cleanup

Once you've cleaned up the resources, the GitHub Actions CD pipeline will automatically deploy fresh resources on the next push to main.
