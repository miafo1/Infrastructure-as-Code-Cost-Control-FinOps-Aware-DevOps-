# FinOps-Aware Infrastructure as Code (AWS)

This production-style Terraform project demonstrates how to build and manage AWS infrastructure with a strict "Cost-First" mindset.

## 🚀 Key Features
- **Modular Design**: Reusuable VPC, EC2, IAM, and S3 modules.
- **FinOps Governance**: Mandatory tagging, lifecycle rules, and instance type constraints.
- **Cost Estimation**: Pre-deployment cost breakdown script.
- **Automated Destruction**: One-click cleanup to prevent "zombie" resource costs.
- **Budgeting**: AWS Budget alarm configured at $1.00 USD.

## 📁 Project Structure
- `terraform/main.tf`: Orchestration.
- `terraform/locals.tf`: Tagging and cost constants.
- `terraform/modules/`: Specialized infrastructure components.
- `terraform/scripts/`: Cost estimation and destruction utilities.

## 🛠️ Getting Started
1. **Initialize**: `terraform init`
2. **Estimate Cost**: `./scripts/cost_estimate.sh`
3. **Deploy**: `terraform apply`
4. **Cleanup**: `./scripts/destroy_env.sh`

## 💰 Cost Control Strategy
- **Lifecycle Policies**: S3 logs expire after 7 days.
- **Instance Enforcement**: `lifecycle` preconditions block any instance type except `t2.micro/t3.micro`.
- **EBS Optimization**: Uses `gp3` (20% cheaper than gp2) with minimal 8GB throughput.
- **Tagging**: Every resource is tagged with `AutoTerminate=true` for automated cleanup jobs.

---
*Created by Antigravity (FinOps DevOps Architect)*
