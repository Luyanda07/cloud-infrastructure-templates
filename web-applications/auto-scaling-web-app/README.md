# Auto Scaling Web Application

Highly available web application with Application Load Balancer, Auto Scaling Group, and RDS database across multiple Availability Zones. Built for production workloads with comprehensive monitoring and security.

## 🏗️ Architecture

This template creates:
- **Application Load Balancer (ALB)** for traffic distribution
- **Auto Scaling Group (ASG)** with EC2 instances
- **RDS Multi-AZ Database** for high availability
- **VPC with Public/Private Subnets** (optional)
- **Security Groups** with least privilege access
- **IAM Roles** for EC2 instances
- **S3 Buckets** for application assets and logs
- **CloudWatch Monitoring** and auto-scaling policies
- **Secrets Manager** for database credentials

## 📋 Prerequisites

- AWS CLI configured with appropriate permissions
- EC2 Key Pair for SSH access (optional)
- VPC with public and private subnets (or let template create one)

## 🚀 Quick Start

### CloudFormation Deployment

```bash
# Clone the repository
git clone https://github.com/Luyanda07/cloud-infrastructure-templates.git
cd cloud-infrastructure-templates/web-applications/auto-scaling-web-app/cloudformation

# Deploy with new VPC
aws cloudformation create-stack \
  --stack-name my-web-app \
  --template-body file://web-app.yaml \
  --parameters \
    ParameterKey=ProjectName,ParameterValue=myapp \
    ParameterKey=Environment,ParameterValue=prod \
    ParameterKey=KeyPairName,ParameterValue=my-key-pair \
  --capabilities CAPABILITY_NAMED_IAM

# Deploy with existing VPC
aws cloudformation create-stack \
  --stack-name my-web-app \
  --template-body file://web-app.yaml \
  --parameters \
    ParameterKey=ProjectName,ParameterValue=myapp \
    ParameterKey=Environment,ParameterValue=prod \
    ParameterKey=VpcId,ParameterValue=vpc-12345678 \
    ParameterKey=PublicSubnetIds,ParameterValue="subnet-12345678,subnet-87654321" \
    ParameterKey=PrivateSubnetIds,ParameterValue="subnet-abcdefgh,subnet-hgfedcba" \
    ParameterKey=KeyPairName,ParameterValue=my-key-pair \
  --capabilities CAPABILITY_NAMED_IAM
```

### Terraform Deployment

```bash
# Navigate to Terraform directory
cd ../terraform

# Initialize Terraform
terraform init

# Create terraform.tfvars file
cat > terraform.tfvars << EOF
project_name = "myapp"
environment  = "prod"

# EC2 Configuration
instance_type = "t3.small"
key_pair_name = "my-key-pair"

# Auto Scaling Configuration
asg_min_size = 2
asg_max_size = 6
asg_desired_capacity = 2

# Database Configuration
db_engine = "mysql"
db_engine_version = "8.0.35"
db_instance_class = "db.t3.small"
db_allocated_storage = 100
db_multi_az = true

# Optional: Use existing VPC
# vpc_id = "vpc-12345678"
EOF

# Deploy
terraform plan
terraform apply
```

## 🔧 Configuration Options

### Instance Configuration
```yaml
# CloudFormation
InstanceType: t3.medium
KeyPairName: my-key-pair

# Auto Scaling
MinSize: 2
MaxSize: 6
DesiredCapacity: 2
```

```hcl
# Terraform
instance_type = "t3.medium"
key_pair_name = "my-key-pair"

asg_min_size = 2
asg_max_size = 6
asg_desired_capacity = 2
```

### Database Configuration
```yaml
# CloudFormation
DBInstanceClass: db.t3.small
DBEngine: mysql
DBEngineVersion: "8.0"
AllocatedStorage: 100
MultiAZ: true
```

```hcl
# Terraform
db_engine = "mysql"
db_engine_version = "8.0.35"
db_instance_class = "db.t3.small"
db_allocated_storage = 100
db_multi_az = true
```

### Network Configuration
```hcl
# Use existing VPC
vpc_id = "vpc-12345678"

# Or create new VPC
vpc_cidr = "10.0.0.0/16"
```

## 🔐 Security Features

### Network Security
- **VPC Isolation**: Resources deployed in private subnets
- **Security Groups**: Least privilege access rules
- **ALB Security**: Only HTTP/HTTPS from internet
- **Database Security**: Access only from web servers

### Access Control
- **IAM Roles**: EC2 instances use roles, not keys
- **Secrets Manager**: Database credentials securely stored
- **SSM Access**: SSH via Systems Manager (no direct SSH)
- **S3 Bucket Policies**: Restricted access to application assets

### Data Protection
- **RDS Encryption**: Database encrypted at rest
- **S3 Encryption**: Application assets encrypted
- **ALB Logs**: Access logs for audit trail
- **CloudWatch Logs**: Application and system logs

## 📊 Monitoring & Auto Scaling

### Auto Scaling Policies
- **Scale Up**: CPU > 70% for 10 minutes
- **Scale Down**: CPU < 20% for 10 minutes
- **Cooldown**: 5 minutes between scaling actions

### CloudWatch Alarms
- **High CPU**: Triggers scale-up policy
- **Low CPU**: Triggers scale-down policy
- **Database Connections**: Monitors RDS connection count
- **ALB Target Health**: Monitors healthy instances

### Monitoring Dashboard
```bash
# View CloudWatch metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name RequestCount \
  --dimensions Name=LoadBalancer,Value=app/my-web-app-alb/1234567890abcdef \
  --start-time 2023-12-01T00:00:00Z \
  --end-time 2023-12-02T00:00:00Z \
  --period 3600 \
  --statistics Sum
```

## 🛠️ Application Deployment

### Deploy Your Application

```bash
# Get ALB DNS name
ALB_DNS=$(aws cloudformation describe-stacks \
  --stack-name my-web-app \
  --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerURL`].OutputValue' \
  --output text)

echo "Application URL: $ALB_DNS"

# Upload application assets to S3
S3_BUCKET=$(aws cloudformation describe-stacks \
  --stack-name my-web-app \
  --query 'Stacks[0].Outputs[?OutputKey==`S3BucketName`].OutputValue' \
  --output text)

aws s3 sync ./app-assets s3://$S3_BUCKET/
```

### Database Connection

```bash
# Get database credentials from Secrets Manager
SECRET_ARN=$(aws cloudformation describe-stacks \
  --stack-name my-web-app \
  --query 'Stacks[0].Outputs[?OutputKey==`DatabaseCredentialsSecret`].OutputValue' \
  --output text)

aws secretsmanager get-secret-value --secret-id $SECRET_ARN
```

### Application Configuration Examples

#### PHP Application
```php
<?php
// Database connection using Secrets Manager
$secret = json_decode(file_get_contents('http://169.254.169.254/latest/meta-data/iam/security-credentials/MyAppRole'));
$db_config = json_decode($secret['SecretString']);

$pdo = new PDO(
    "mysql:host={$db_config['host']};dbname={$db_config['dbname']}",
    $db_config['username'],
    $db_config['password']
);
?>
```

#### Node.js Application
```javascript
const AWS = require('aws-sdk');
const secretsManager = new AWS.SecretsManager();

async function getDbConfig() {
    const secret = await secretsManager.getSecretValue({
        SecretId: process.env.DB_SECRET_ARN
    }).promise();
    
    return JSON.parse(secret.SecretString);
}
```

#### Python Application
```python
import boto3
import json

def get_db_config():
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=os.environ['DB_SECRET_ARN'])
    return json.loads(response['SecretString'])
```

## 🔄 Scaling & Performance

### Manual Scaling
```bash
# Scale up immediately
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name my-web-app-asg \
  --desired-capacity 4

# Update launch template
aws ec2 create-launch-template-version \
  --launch-template-id lt-1234567890abcdef0 \
  --source-version 1 \
  --launch-template-data '{"InstanceType":"t3.large"}'
```

### Performance Optimization
```bash
# Enable detailed monitoring
aws autoscaling enable-metrics-collection \
  --auto-scaling-group-name my-web-app-asg \
  --metrics GroupMinSize GroupMaxSize GroupDesiredCapacity

# Configure ALB stickiness
aws elbv2 modify-target-group-attributes \
  --target-group-arn $TARGET_GROUP_ARN \
  --attributes Key=stickiness.enabled,Value=true
```

## 💰 Cost Optimization

### Instance Right-Sizing
```bash
# Analyze CloudWatch metrics for right-sizing
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=AutoScalingGroupName,Value=my-web-app-asg \
  --start-time 2023-12-01T00:00:00Z \
  --end-time 2023-12-08T00:00:00Z \
  --period 86400 \
  --statistics Average,Maximum
```

### Cost Monitoring
```bash
# Get cost breakdown
aws ce get-cost-and-usage \
  --time-period Start=2023-12-01,End=2023-12-31 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE
```

### Spot Instances (Advanced)
```json
{
  "LaunchTemplateData": {
    "InstanceMarketOptions": {
      "MarketType": "spot",
      "SpotOptions": {
        "MaxPrice": "0.05",
        "SpotInstanceType": "one-time"
      }
    }
  }
}
```

## 🧪 Testing

### Load Testing
```bash
# Install Apache Bench
sudo yum install -y httpd-tools

# Run load test
ab -n 1000 -c 10 http://$ALB_DNS/

# Monitor during load test
watch -n 5 'aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name RequestCount \
  --dimensions Name=LoadBalancer,Value=$ALB_ARN \
  --start-time $(date -u -d "5 minutes ago" +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Sum'
```

### Health Checks
```bash
# Test ALB health check endpoint
curl -I http://$ALB_DNS/health

# Check target group health
aws elbv2 describe-target-health --target-group-arn $TARGET_GROUP_ARN
```

## 🔄 Maintenance

### Rolling Updates
```bash
# Update launch template
aws ec2 create-launch-template-version \
  --launch-template-id $LAUNCH_TEMPLATE_ID \
  --source-version $Latest \
  --launch-template-data file://new-template-data.json

# Trigger instance refresh
aws autoscaling start-instance-refresh \
  --auto-scaling-group-name my-web-app-asg \
  --preferences MinHealthyPercentage=50,InstanceWarmup=300
```

### Database Maintenance
```bash
# Create RDS snapshot before maintenance
aws rds create-db-snapshot \
  --db-instance-identifier my-web-app-db \
  --db-snapshot-identifier my-web-app-db-$(date +%Y%m%d)

# Monitor RDS performance
aws rds describe-db-instances --db-instance-identifier my-web-app-db
```

## 📚 Well-Architected Principles

- **Security**: VPC isolation, IAM roles, encryption, Secrets Manager
- **Reliability**: Multi-AZ deployment, auto-scaling, health checks
- **Performance**: Load balancing, auto-scaling, CloudWatch monitoring
- **Cost Optimization**: Right-sizing, auto-scaling policies, cost monitoring
- **Operational Excellence**: Infrastructure as Code, logging, monitoring

## 🔗 Related Templates

- [VPC Multi-AZ](../../networking/vpc-multi-az/) - Network foundation
- [RDS Multi-AZ](../../databases/rds-multi-az/) - Advanced database setup
- [EKS Cluster](../../containers/eks-cluster/) - Container orchestration

## 📖 Additional Resources

- [Auto Scaling Best Practices](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-benefits.html)
- [Application Load Balancer Guide](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [RDS Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html)

## 🆘 Troubleshooting

### Common Issues

**Instances failing health checks**
```bash
# Check target group health
aws elbv2 describe-target-health --target-group-arn $TARGET_GROUP_ARN

# Check instance logs
aws logs tail /aws/ec2/my-web-app --follow

# SSH via Systems Manager
aws ssm start-session --target i-1234567890abcdef0
```

**Auto scaling not working**
```bash
# Check scaling policies
aws autoscaling describe-policies --auto-scaling-group-name my-web-app-asg

# Check CloudWatch alarms
aws cloudwatch describe-alarms --alarm-names my-web-app-high-cpu

# Manual scaling test
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name my-web-app-asg \
  --desired-capacity 3
```

**Database connection issues**
```bash
# Test database connectivity from EC2
mysql -h $DB_ENDPOINT -u admin -p

# Check security group rules
aws ec2 describe-security-groups --group-ids $DB_SECURITY_GROUP_ID

# Check RDS status
aws rds describe-db-instances --db-instance-identifier my-web-app-db
```

## 📄 License

This template is released under the MIT License. See [LICENSE](../../../LICENSE) for details.