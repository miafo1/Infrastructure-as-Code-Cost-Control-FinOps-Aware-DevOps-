module "vpc" {
  source = "./modules/vpc"

  environment        = var.environment
  aws_region         = var.aws_region
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

module "iam" {
  source = "./modules/iam"

  environment = var.environment
}

module "ec2" {
  source = "./modules/ec2"

  environment   = var.environment
  instance_type = local.instance_type
  subnet_id     = module.vpc.public_subnet_id
}

module "s3" {
  source = "./modules/s3"

  bucket_name = "finops-logs-${var.aws_account_id}-${var.environment}"
}

# AWS Budgets - Prevent unexpected charges
resource "aws_budgets_budget" "finops_budget" {
  name              = "monthly-free-tier-budget"
  budget_type       = "COST"
  limit_amount      = "1.0"
  limit_unit        = "USD"
  time_period_start = "2024-01-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["admin@example.com"]
  }
}
