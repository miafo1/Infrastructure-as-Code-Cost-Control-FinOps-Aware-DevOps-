locals {
  environment = var.environment
  project     = "finops-iac"
  owner       = "cloud-architect"

  common_tags = {
    Environment       = local.environment
    Project           = local.project
    Owner             = local.owner
    CostCenter        = "Research-And-Development"
    ManagedBy         = "Terraform"
    FinOps_Aware      = "true"
    AutoTerminate     = "true"
    FreeTier_Eligible = "true"
  }

  # Cost Optimization Constants
  instance_type = "t3.micro" # Free Tier eligible in many regions
  ebs_volume_size = 8        # GB
}
