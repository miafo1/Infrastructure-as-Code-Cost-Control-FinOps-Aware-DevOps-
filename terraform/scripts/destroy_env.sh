#!/bin/bash
# Clean Teardown Script

echo "🛑 Starting resource destruction..."
terraform destroy -auto-approve

if [ $? -eq 0 ]; then
    echo "✅ Infrastructure destroyed successfully."
    echo "💰 Current estimated cost: $0.00"
else
    echo "❌ Error during destruction. Please check manual resources."
fi
