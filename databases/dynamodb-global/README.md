# DynamoDB with Global Tables

DynamoDB setup with Global Tables for multi-region replication, point-in-time recovery, and comprehensive monitoring.

## 🏗️ Architecture

This template creates:
- **DynamoDB Table** with flexible schema design
- **Global Secondary Indexes** for query flexibility
- **DynamoDB Streams** for real-time data processing
- **KMS Encryption** for data at rest
- **Point-in-Time Recovery** for data protection
- **CloudWatch Monitoring** with custom dashboard
- **Lambda Stream Processor** for event handling
- **IAM Roles** with least privilege access
- **CloudWatch Alarms** for proactive monitoring

## 📋 Prerequisites

- AWS CLI configured with appropriate permissions
- Multiple AWS regions for Global Tables setup
- Understanding of DynamoDB single-table design patterns

## 🚀 Quick Start

### 1. Clone and Navigate
```bash
git clone https://github.com/Luyanda07/cloud-infrastructure-templates.git
cd cloud-infrastructure-templates/databases/dynamodb-global/cloudformation
```

### 2. Deploy Primary Table
```bash
aws cloudformation create-stack \
  --stack-name myapp-prod-dynamodb \
  --template-body file://dynamodb-global.yaml \
  --parameters \
    ParameterKey=ProjectName,ParameterValue=myapp \
    ParameterKey=Environment,ParameterValue=prod \
    ParameterKey=TableName,ParameterValue=MainTable \
    ParameterKey=BillingMode,ParameterValue=PAY_PER_REQUEST \
  --capabilities CAPABILITY_NAMED_IAM
```

### 3. Set Up Global Tables
After the primary table is created, set up Global Tables in additional regions:

```bash
# Enable Global Tables (run from primary region)
aws dynamodb create-global-table \
  --global-table-name myapp-prod-MainTable \
  --replication-group RegionName=us-east-1 RegionName=us-west-2 RegionName=eu-west-1
```

### 4. Verify Setup
```bash
# Check table status
aws dynamodb describe-table --table-name myapp-prod-MainTable

# Check Global Table status
aws dynamodb describe-global-table --global-table-name myapp-prod-MainTable
```

## 🔧 Configuration Options

### Billing Modes
```yaml
# Pay-per-request (recommended for variable workloads)
BillingMode: PAY_PER_REQUEST

# Provisioned (for predictable workloads)
BillingMode: PROVISIONED
ReadCapacityUnits: 100
WriteCapacityUnits: 100
```

### Table Schema Design
The template creates a flexible single-table design:
```
Primary Key: PK (Partition Key) + SK (Sort Key)
GSI1: GSI1PK + GSI1SK
GSI2: GSI2PK + GSI2SK
```

Example data patterns:
```json
// User record
{
  "PK": "USER#12345",
  "SK": "PROFILE",
  "GSI1PK": "USER#EMAIL",
  "GSI1SK": "user@example.com",
  "name": "John Doe",
  "email": "user@example.com"
}

// User's order
{
  "PK": "USER#12345",
  "SK": "ORDER#67890",
  "GSI1PK": "ORDER#STATUS",
  "GSI1SK": "PENDING",
  "GSI2PK": "ORDER#DATE",
  "GSI2SK": "2023-12-01",
  "total": 99.99
}
```

### Stream Configuration
```yaml
# Stream view types
StreamViewType: NEW_AND_OLD_IMAGES  # Full item data
StreamViewType: NEW_IMAGE           # New item only
StreamViewType: OLD_IMAGE           # Old item only
StreamViewType: KEYS_ONLY           # Key attributes only
```

## 🔐 Security Features

- **Encryption at Rest**: Customer-managed KMS key
- **Encryption in Transit**: HTTPS/TLS enforced
- **IAM Integration**: Fine-grained access control
- **VPC Endpoints**: Private network access (optional)
- **Deletion Protection**: Prevent accidental deletion

## 📊 Monitoring & Alerting

### CloudWatch Metrics
- **Consumed Capacity**: Read/write capacity utilization
- **Throttled Requests**: Rate limiting events
- **Request Latency**: Response time metrics
- **Item Count**: Table size metrics

### CloudWatch Alarms
- **Read/Write Throttling**: Immediate alerts
- **High Capacity Utilization**: Scaling alerts
- **Error Rates**: Operational alerts

### Custom Dashboard
The template creates a comprehensive dashboard showing:
- Capacity utilization trends
- Throttling events
- Request latency by operation
- Table size growth

## 🌍 Global Tables Setup

### Manual Setup via Console
1. Go to DynamoDB Console
2. Select your table
3. Navigate to "Global Tables" tab
4. Click "Create replica"
5. Select target regions
6. Wait for replication to complete

### CLI Setup
```bash
# Create Global Table
aws dynamodb create-global-table \
  --global-table-name myapp-prod-MainTable \
  --replication-group RegionName=us-east-1 RegionName=us-west-2

# Add additional region
aws dynamodb update-global-table \
  --global-table-name myapp-prod-MainTable \
  --replica-updates Create={RegionName=eu-west-1}

# Check status
aws dynamodb describe-global-table \
  --global-table-name myapp-prod-MainTable
```

### Global Table Considerations
- **Eventual Consistency**: Cross-region replication is eventually consistent
- **Conflict Resolution**: Last writer wins
- **Billing**: Charged for replicated write capacity in each region
- **Latency**: Local reads, cross-region writes

## 🛠️ Application Integration

### AWS SDK Examples

#### Python (Boto3)
```python
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('myapp-prod-MainTable')

# Put item
table.put_item(
    Item={
        'PK': 'USER#12345',
        'SK': 'PROFILE',
        'name': 'John Doe',
        'email': 'john@example.com'
    }
)

# Get item
response = table.get_item(
    Key={
        'PK': 'USER#12345',
        'SK': 'PROFILE'
    }
)

# Query with GSI
response = table.query(
    IndexName='GSI1',
    KeyConditionExpression=Key('GSI1PK').eq('USER#EMAIL')
)
```

#### Node.js
```javascript
const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

// Put item
const putParams = {
    TableName: 'myapp-prod-MainTable',
    Item: {
        PK: 'USER#12345',
        SK: 'PROFILE',
        name: 'John Doe',
        email: 'john@example.com'
    }
};

await dynamodb.put(putParams).promise();

// Query
const queryParams = {
    TableName: 'myapp-prod-MainTable',
    KeyConditionExpression: 'PK = :pk',
    ExpressionAttributeValues: {
        ':pk': 'USER#12345'
    }
};

const result = await dynamodb.query(queryParams).promise();
```

#### Java
```java
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;

DynamoDbClient client = DynamoDbClient.create();

// Put item
PutItemRequest putRequest = PutItemRequest.builder()
    .tableName("myapp-prod-MainTable")
    .item(Map.of(
        "PK", AttributeValue.builder().s("USER#12345").build(),
        "SK", AttributeValue.builder().s("PROFILE").build(),
        "name", AttributeValue.builder().s("John Doe").build()
    ))
    .build();

client.putItem(putRequest);
```

## 🔄 Backup & Recovery

### Point-in-Time Recovery
```bash
# Enable PITR (if not enabled in template)
aws dynamodb update-continuous-backups \
  --table-name myapp-prod-MainTable \
  --point-in-time-recovery-specification PointInTimeRecoveryEnabled=true

# Restore to specific time
aws dynamodb restore-table-to-point-in-time \
  --source-table-name myapp-prod-MainTable \
  --target-table-name myapp-prod-MainTable-restored \
  --restore-date-time 2023-12-01T10:00:00.000Z
```

### On-Demand Backups
```bash
# Create backup
aws dynamodb create-backup \
  --table-name myapp-prod-MainTable \
  --backup-name myapp-prod-MainTable-backup-$(date +%Y%m%d)

# Restore from backup
aws dynamodb restore-table-from-backup \
  --target-table-name myapp-prod-MainTable-restored \
  --backup-arn arn:aws:dynamodb:region:account:table/myapp-prod-MainTable/backup/01234567890123-abcdefgh
```

## 💰 Cost Optimization

### Billing Mode Selection
- **Pay-per-request**: Variable workloads, unpredictable traffic
- **Provisioned**: Steady, predictable workloads

### Capacity Planning
```bash
# Monitor capacity utilization
aws cloudwatch get-metric-statistics \
  --namespace AWS/DynamoDB \
  --metric-name ConsumedReadCapacityUnits \
  --dimensions Name=TableName,Value=myapp-prod-MainTable \
  --start-time 2023-12-01T00:00:00Z \
  --end-time 2023-12-02T00:00:00Z \
  --period 3600 \
  --statistics Sum
```

### Global Tables Cost
- Replicated writes charged in each region
- Cross-region data transfer charges
- Consider regional usage patterns

## 🧪 Testing

### Load Testing
```python
import boto3
import concurrent.futures
import time

def write_item(i):
    table.put_item(
        Item={
            'PK': f'TEST#{i}',
            'SK': 'DATA',
            'timestamp': int(time.time()),
            'data': f'test-data-{i}'
        }
    )

# Concurrent writes
with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
    futures = [executor.submit(write_item, i) for i in range(1000)]
    concurrent.futures.wait(futures)
```

### Global Table Testing
```bash
# Write to primary region
aws dynamodb put-item \
  --table-name myapp-prod-MainTable \
  --item '{"PK":{"S":"TEST#GLOBAL"},"SK":{"S":"DATA"},"region":{"S":"us-east-1"}}' \
  --region us-east-1

# Read from secondary region (may take a few seconds)
aws dynamodb get-item \
  --table-name myapp-prod-MainTable \
  --key '{"PK":{"S":"TEST#GLOBAL"},"SK":{"S":"DATA"}}' \
  --region us-west-2
```

## 📚 Well-Architected Principles

- **Security**: Encryption, IAM integration, VPC endpoints
- **Reliability**: Multi-region replication, point-in-time recovery
- **Performance**: Single-digit millisecond latency, auto-scaling
- **Cost Optimization**: Pay-per-request billing, efficient data modeling
- **Operational Excellence**: CloudWatch monitoring, automated backups

## 🔗 Related Templates

- [Serverless API](../../serverless/api-lambda-dynamodb/) - API integration
- [VPC Multi-AZ](../../networking/vpc-multi-az/) - Network foundation
- [EKS Cluster](../../containers/eks-cluster/) - Container integration

## 📖 Additional Resources

- [DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)
- [Single Table Design](https://www.alexdebrie.com/posts/dynamodb-single-table/)
- [Global Tables Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html)

## 🆘 Troubleshooting

### Common Issues

**Throttling errors**
```bash
# Check throttling metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/DynamoDB \
  --metric-name ReadThrottledEvents \
  --dimensions Name=TableName,Value=myapp-prod-MainTable \
  --start-time 2023-12-01T00:00:00Z \
  --end-time 2023-12-02T00:00:00Z \
  --period 300 \
  --statistics Sum
```

**Global Table replication issues**
```bash
# Check Global Table status
aws dynamodb describe-global-table \
  --global-table-name myapp-prod-MainTable

# Check for replication metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/DynamoDB \
  --metric-name ReplicationLatency \
  --dimensions Name=TableName,Value=myapp-prod-MainTable,Name=ReceivingRegion,Value=us-west-2 \
  --start-time 2023-12-01T00:00:00Z \
  --end-time 2023-12-02T00:00:00Z \
  --period 300 \
  --statistics Average
```

**Stream processing errors**
```bash
# Check Lambda function logs
aws logs tail /aws/lambda/myapp-prod-MainTable-stream-processor --follow

# Check event source mapping
aws lambda list-event-source-mappings \
  --function-name myapp-prod-MainTable-stream-processor
```

## 📄 License

This template is released under the MIT License. See [LICENSE](../../../LICENSE) for details.