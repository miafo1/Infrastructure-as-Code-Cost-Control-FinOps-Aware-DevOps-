variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = "string"
  default     = "us-east-1"
}

variable "environment" {
  description = "Execution environment (dev, staging, prod)"
  type        = "string"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_account_id" {
  description = "AWS Account ID (used for unique naming)"
  type        = "string"
  default     = "123456789012" # Placeholder
}
