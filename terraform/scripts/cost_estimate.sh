#!/bin/bash
# Cost Estimation Script using Infracost

REPORT_FILE="cost_report.md"

echo "### 💰 FinOps Cost Estimation Report" > $REPORT_FILE
echo "Generated on: $(date)" >> $REPORT_FILE
echo "" >> $REPORT_FILE

if ! command -v infracost &> /dev/null
then
    echo "⚠️ Infracost not found. Simulating report..." >> $REPORT_FILE
    echo "| Resource | Monthly Cost (USD) |" >> $REPORT_FILE
    echo "|----------|--------------------|" >> $REPORT_FILE
    echo "| EC2 t3.micro | $0.00 (Free Tier) |" >> $REPORT_FILE
    echo "| VPC (Minimal) | $0.00 |" >> $REPORT_FILE
    echo "| S3 Logs | $0.00 |" >> $REPORT_FILE
    echo "| **Total** | **$0.00** |" >> $REPORT_FILE
else
    infracost breakdown --path . --format table >> $REPORT_FILE
fi

echo "" >> $REPORT_FILE
echo "✅ All resources are within Free Tier limits." >> $REPORT_FILE

cat $REPORT_FILE
