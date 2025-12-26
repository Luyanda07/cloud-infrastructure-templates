# RDS Multi-AZ with Read Replicas

Production-ready Amazon RDS setup with Multi-AZ deployment, read replicas, automated backups, and comprehensive monitoring.

## 🏗️ Architecture

This template creates:
- **RDS Primary Instance** with Multi-AZ deployment for high availability
- **Read Replicas** for read scaling and disaster recovery
- **VPC** (optional - can use existing VPC)
- **Security Groups** with least privilege access
- **KMS Encryption** for data at rest
- **Enhanced Monitoring** with CloudWatch integration
- **Parameter Groups** for performance optimization
- **Automated Backups** with point-in-time recovery
- **CloudWatch Alarms** for proactive monitoring
- **Secrets Manager** for credential management

## 📋 Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- VPC with database subnets (or let template create one)

## 🚀 Quick Start

### 1. Clone and Navigate
```bash
git clone https://github.com/Luyanda07/cloud-infrastructure-templates.git
cd cloud-infrastructure-templates/databases/rds-multi-az/terraform
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Configure Variables
Create a `terraform.tfvars` file:
```hcl
project_name = "myapp"
environment  = "prod"

# Database configuration
engine         = "mysql"
engine_version = "8.0.35"
instance_class = "db.t3.small"
database_name  = "myapp"
master_username = "admin"

# Storage configuration
allocated_storage     = 100
max_allocated_storage = 1000
storage_type         = "gp3"

# Network configuration (optional - use existing VPC)
# vpc_id = "vpc-xxxxxxxxx"
allowed_cidr_blocks = ["10.0.0.0/16"]

# Read replicas
read_replica_count = 2
read_replica_instance_class = "db.t3.micro"

# Backup configuration
backup_retention_period = 30
backup_window          = "03:00-04:00"
maintenance_window     = "sun:04:00-sun:05:00"

# Security
deletion_protection = true
skip_final_snapshot = false

# Monitoring
performance_insights_enabled = true
enabled_cloudwatch_logs_exports = ["error", "general", "slow_query"]
```

### 4. Deploy
```bash
terraform plan
terraform apply
```

### 5. Retrieve Database Credentials
```bash
# Get credentials from Secrets Manager
aws secretsmanager get-secret-value \
  --secret-id myapp-prod-db-credentials \
  --query SecretString --output text | jq .
```

## 🔧 Configuration Options

### Database Engines
```hcl
# MySQL
engine = "mysql"
engine_version = "8.0.35"
parameter_group_family = "mysql8.0"
db_port = 3306

# PostgreSQL
engine = "postgres"
engine_version = "15.4"
parameter_group_family = "postgres15"
db_port = 5432

# MariaDB
engine = "mariadb"
engine_version = "10.11.5"
parameter_group_family = "mariadb10.11"
db_port = 3306
```

### Instance Classes
```hcl
# Development
instance_class = "db.t3.micro"   # 1 vCPU, 1 GB RAM

# Production
instance_class = "db.t3.medium"  # 2 vCPU, 4 GB RAM
instance_class = "db.r6g.large"  # 2 vCPU, 16 GB RAM
instance_class = "db.r6g.xlarge" # 4 vCPU, 32 GB RAM
```

### Storage Options
```hcl
# General Purpose SSD (gp3) - Recommended
storage_type = "gp3"
allocated_storage = 100
max_allocated_storage = 1000

# Provisioned IOPS SSD (io1/io2)
storage_type = "io2"
allocated_storage = 100
iops = 3000
```

### Read Replica Configuration
```hcl
read_replica_count = 3
read_replica_instance_class = "db.t3.small"

# Cross-region read replicas (manual setup required)
# Different regions for disaster recovery
```

## 🔐 Security Features

- **Encryption at Rest**: Customer-managed KMS key
- **Encryption in Transit**: SSL/TLS enforced
- **Network Isolation**: VPC with security groups
- **Access Control**: IAM-based authentication support
- **Credential Management**: AWS Secrets Manager integration
- **Audit Logging**: CloudWatch Logs integration

## 📊 Monitoring & Alerting

### CloudWatch Alarms
- **CPU Utilization**: > 80% for 10 minutes
- **Database Connections**: > threshold for 10 minutes
- **Free Storage Space**: < 2GB
- **Read/Write Latency**: > 200ms

### Performance Insights
- **Query Performance**: Top SQL statements
- **Wait Events**: Database bottlenecks
- **Database Load**: Real-time performance metrics

### Enhanced Monitoring
- **OS Metrics**: CPU, memory, disk I/O
- **Process List**: Active database processes
- **File System**: Disk usage and performance

## 🔄 Backup & Recovery

### Automated Backups
- **Point-in-Time Recovery**: Up to 35 days
- **Backup Window**: Configurable maintenance window
- **Cross-Region Backup**: Manual setup for disaster recovery

### Manual Snapshots
```bash
# Create manual snapshot
aws rds create-db-snapshot \
  --db-instance-identifier myapp-prod-db \
  --db-snapshot-identifier myapp-prod-db-manual-$(date +%Y%m%d)

# Restore from snapshot
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier myapp-prod-db-restored \
  --db-snapshot-identifier myapp-prod-db-manual-20231201
```

## 🛠️ Database Management

### Connection Examples

#### MySQL
```bash
# Connect to primary instance
mysql -h myapp-prod-db.cluster-xyz.us-west-2.rds.amazonaws.com \
      -u admin -p myapp

# Connect to read replica
mysql -h myapp-prod-db-read-replica-1.xyz.us-west-2.rds.amazonaws.com \
      -u admin -p myapp
```

#### PostgreSQL
```bash
# Connect to primary instance
psql -h myapp-prod-db.cluster-xyz.us-west-2.rds.amazonaws.com \
     -U admin -d myapp

# Connection string
postgresql://admin:password@endpoint:5432/myapp
```

### Application Configuration

#### Java (Spring Boot)
```yaml
spring:
  datasource:
    url: jdbc:mysql://myapp-prod-db.cluster-xyz.us-west-2.rds.amazonaws.com:3306/myapp
    username: admin
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false
```

#### Python (Django)
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'myapp',
        'USER': 'admin',
        'PASSWORD': os.environ['DB_PASSWORD'],
        'HOST': 'myapp-prod-db.cluster-xyz.us-west-2.rds.amazonaws.com',
        'PORT': '3306',
    }
}
```

## 💰 Cost Optimization

### Instance Right-Sizing
- **Start Small**: Begin with t3.micro for development
- **Monitor Usage**: Use CloudWatch metrics to optimize
- **Reserved Instances**: 1-3 year commitments for production

### Storage Optimization
- **gp3 Storage**: Better price/performance than gp2
- **Storage Autoscaling**: Automatic growth as needed
- **Backup Retention**: Balance between recovery needs and cost

### Read Replica Strategy
- **Regional Replicas**: Lower cost than cross-region
- **Instance Classes**: Use smaller instances for read workloads
- **Scaling**: Add/remove replicas based on read traffic

## 🧪 Testing

### Connection Testing
```bash
# Test primary instance connectivity
nc -zv myapp-prod-db.cluster-xyz.us-west-2.rds.amazonaws.com 3306

# Test read replica connectivity
nc -zv myapp-prod-db-read-replica-1.xyz.us-west-2.rds.amazonaws.com 3306
```

### Performance Testing
```sql
-- Test query performance
EXPLAIN SELECT * FROM users WHERE email = 'test@example.com';

-- Check slow query log
SELECT * FROM mysql.slow_log ORDER BY start_time DESC LIMIT 10;

-- Monitor connections
SHOW PROCESSLIST;
```

## 🔄 Maintenance

### Version Upgrades
```bash
# Check available versions
aws rds describe-db-engine-versions --engine mysql

# Upgrade (during maintenance window)
terraform apply -var="engine_version=8.0.36"
```

### Parameter Tuning
```hcl
db_parameters = [
  {
    name  = "innodb_buffer_pool_size"
    value = "{DBInstanceClassMemory*3/4}"
  },
  {
    name  = "max_connections"
    value = "200"
  },
  {
    name  = "slow_query_log"
    value = "1"
  }
]
```

## 📚 Well-Architected Principles

- **Security**: Encryption, network isolation, credential management
- **Reliability**: Multi-AZ deployment, automated backups, read replicas
- **Performance**: Parameter optimization, Performance Insights, monitoring
- **Cost Optimization**: Right-sizing, storage optimization, Reserved Instances
- **Operational Excellence**: Infrastructure as Code, monitoring, automation

## 🔗 Related Templates

- [VPC Multi-AZ](../../networking/vpc-multi-az/) - Network foundation
- [Auto Scaling Web App](../../web-applications/auto-scaling-web-app/) - Application layer
- [EKS Cluster](../../containers/eks-cluster/) - Container orchestration

## 📖 Additional Resources

- [RDS Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html)
- [RDS Performance Insights](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.html)
- [RDS Security](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.html)

## 🆘 Troubleshooting

### Common Issues

**Connection timeouts**
```bash
# Check security group rules
aws ec2 describe-security-groups --group-ids sg-xxxxxxxxx

# Test network connectivity
telnet myapp-prod-db.cluster-xyz.us-west-2.rds.amazonaws.com 3306
```

**High CPU utilization**
```sql
-- Check running queries
SHOW FULL PROCESSLIST;

-- Analyze slow queries
SELECT * FROM mysql.slow_log ORDER BY query_time DESC LIMIT 10;
```

**Storage space issues**
```bash
# Check storage metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name FreeStorageSpace \
  --dimensions Name=DBInstanceIdentifier,Value=myapp-prod-db \
  --start-time 2023-12-01T00:00:00Z \
  --end-time 2023-12-02T00:00:00Z \
  --period 3600 \
  --statistics Average
```

## 📄 License

This template is released under the MIT License. See [LICENSE](../../../LICENSE) for details.