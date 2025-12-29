#!/bin/bash
# Enhanced Cleanup - Deletes Unused VPCs to free up quota
# WARNING: This deletes VPCs that are NOT the "default" VPC. Use with caution.

echo "🧹 Starting VPC Cleanup..."
export AWS_REGION=us-east-1

# Get list of VPC IDs that are NOT default
VPCS=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=false" --query "Vpcs[*].VpcId" --output text)

if [ -z "$VPCS" ]; then
    echo "✅ No custom VPCs found to delete."
    exit 0
fi

echo "⚠️ Found the following custom VPCs: $VPCS"

for vpc in $VPCS; do
    echo "Processing VPC: $vpc..."
    
    # Detach and delete IGWs
    igws=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$vpc" --query "InternetGateways[*].InternetGatewayId" --output text)
    for igw in $igws; do
        echo "  - Detaching and deleting IGW: $igw"
        aws ec2 detach-internet-gateway --internet-gateway-id $igw --vpc-id $vpc
        aws ec2 delete-internet-gateway --internet-gateway-id $igw
    done

    # Delete Subnets
    subnets=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query "Subnets[*].SubnetId" --output text)
    for subnet in $subnets; do
        echo "  - Deleting Subnet: $subnet"
        aws ec2 delete-subnet --subnet-id $subnet
    done

    # Delete Route Tables (Main RT implies association, custom RTs deleted)
    rts=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$vpc" --query "RouteTables[?Associations[0].Main!=\`true\`].RouteTableId" --output text)
    for rt in $rts; do
        echo "  - Deleting Route Table: $rt"
        aws ec2 delete-route-table --route-table-id $rt
    done

    # Finally, delete the VPC
    echo "  - Deleting VPC: $vpc"
    aws ec2 delete-vpc --vpc-id $vpc
done

echo "✅ VPC Cleanup Complete. You should now be under the limit."
