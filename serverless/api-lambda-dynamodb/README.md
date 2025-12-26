# Serverless REST API Template

This template creates a complete serverless REST API using AWS Lambda, API Gateway, and DynamoDB with proper IAM roles, monitoring, and security configurations.

## Architecture

- **API Gateway** REST API with CORS support
- **Lambda Functions** for CRUD operations (Python 3.11)
- **DynamoDB Table** with on-demand billing and encryption
- **IAM Roles** with least-privilege access
- **CloudWatch Monitoring** with alarms
- **X-Ray Tracing** for distributed tracing

## API Endpoints

| Method | Path | Function | Description |
|--------|------|----------|-------------|
| GET | /items | get_items | List all items |
| GET | /items/{id} | get_item | Get specific item |
| POST | /items | create_item | Create new item |
| PUT | /items/{id} | update_item | Update existing item |
| DELETE | /items/{id} | delete_item | Delete item |

## Well-Architected Framework Compliance

### Security
- IAM roles with least-privilege access
- DynamoDB encryption at rest
- API Gateway with AWS_IAM authorization
- X-Ray tracing for security monitoring

### Reliability
- DynamoDB point-in-time recovery enabled
- CloudWatch alarms for monitoring
- Multi-AZ DynamoDB deployment
- Lambda retry mechanisms

### Performance Efficiency
- On-demand DynamoDB billing for variable workloads
- Lambda functions with optimized memory allocation
- API Gateway caching capabilities

### Cost Optimization
- Pay-per-request DynamoDB billing
- Lambda pay-per-execution model
- CloudWatch log retention policies

### Operational Excellence
- Comprehensive monitoring and alerting
- Structured logging
- Infrastructure as Code

## Usage

### CloudFormation (SAM)
```bash
# Install SAM CLI first
pip install aws-sam-cli

# Deploy using SAM
sam build
sam deploy --guided
```

### CloudFormation (Traditional)
```bash
aws cloudformation create-stack \
  --stack-name serverless-api \
  --template-body file://serverless-api.yaml \
  --parameters ParameterKey=ProjectName,ParameterValue=myapi \
               ParameterKey=Environment,ParameterValue=prod \
  --capabilities CAPABILITY_IAM
```

### Terraform
```bash
cd terraform/
terraform init
terraform plan -var="project_name=myapi" -var="environment=prod"
terraform apply
```

## Parameters

| Parameter | Description | Default | Allowed Values |
|-----------|-------------|---------|----------------|
| Environment | Environment name | dev | dev, staging, prod |
| ProjectName | Project name for resource naming | serverless-api | Lowercase letters, numbers, hyphens |
| TableName | DynamoDB table name | items | Valid table name |
| ApiStageName | API Gateway stage name | v1 | Valid stage name |

## Lambda Function Structure

Each Lambda function should be organized as follows:
```
src/
├── get_items/
│   └── app.py
├── get_item/
│   └── app.py
├── create_item/
│   └── app.py
├── update_item/
│   └── app.py
└── delete_item/
    └── app.py
```

## Sample Lambda Function (get_items)

```python
import json
import boto3
import os
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super(DecimalEncoder, self).default(o)

def lambda_handler(event, context):
    try:
        response = table.scan()
        items = response['Items']
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'items': items,
                'count': len(items)
            }, cls=DecimalEncoder)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': str(e)
            })
        }
```

## Testing the API

```bash
# Get API URL from stack outputs
API_URL=$(aws cloudformation describe-stacks \
  --stack-name serverless-api \
  --query 'Stacks[0].Outputs[?OutputKey==`ApiGatewayUrl`].OutputValue' \
  --output text)

# Test endpoints
curl -X GET $API_URL/items
curl -X POST $API_URL/items -d '{"name":"test","description":"test item"}'
curl -X GET $API_URL/items/123
curl -X PUT $API_URL/items/123 -d '{"name":"updated","description":"updated item"}'
curl -X DELETE $API_URL/items/123
```

## Monitoring

The template includes CloudWatch alarms for:
- DynamoDB throttling
- Lambda function errors
- API Gateway 4xx/5xx errors

## Security Considerations

- API Gateway uses AWS_IAM authorization
- Lambda functions have minimal IAM permissions
- DynamoDB table has encryption at rest enabled
- All resources are tagged for governance
- X-Ray tracing enabled for security monitoring

## Cost Optimization

- DynamoDB uses on-demand billing (pay per request)
- Lambda functions are right-sized for memory allocation
- CloudWatch log retention is set to 30 days
- Consider reserved capacity for DynamoDB if usage is predictable