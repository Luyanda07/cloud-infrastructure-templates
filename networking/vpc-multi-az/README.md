# Multi-AZ VPC Template

This template creates a production-ready VPC with public and private subnets across multiple Availability Zones, NAT gateways, and proper routing.

## Architecture

- **VPC** with customizable CIDR block
- **Public Subnets** (2) across different AZs with Internet Gateway access
- **Private Subnets** (2) across different AZs with NAT Gateway access
- **Database Subnets** (2) isolated subnets for database resources
- **NAT Gateways** (2) for high availability
- **Route Tables** properly configured for each subnet type
- **VPC Flow Logs** for network monitoring
- **Security Groups** with default configurations

## Well-Architected Framework Compliance

### Security
- VPC Flow Logs enabled for network monitoring
- Separate subnets for different tiers (public, private, database)
- Default security group with restrictive rules

### Reliability
- Multi-AZ deployment across 2 Availability Zones
- Redundant NAT Gateways for high availability
- Proper subnet isolation

### Performance Efficiency
- Optimized routing tables
- Regional resources for low latency

### Cost Optimization
- Pay-per-use NAT Gateways
- Efficient CIDR block allocation

### Operational Excellence
- Comprehensive tagging strategy
- CloudWatch integration via Flow Logs

## Usage

### CloudFormation (YAML)
```bash
aws cloudformation create-stack \
  --stack-name my-vpc \
  --template-body file://vpc-multi-az.yaml \
  --parameters ParameterKey=ProjectName,ParameterValue=myproject \
               ParameterKey=Environment,ParameterValue=prod \
               ParameterKey=VpcCidr,ParameterValue=10.0.0.0/16
```

### CloudFormation (JSON)
```bash
aws cloudformation create-stack \
  --stack-name my-vpc \
  --template-body file://vpc-multi-az.json \
  --parameters ParameterKey=ProjectName,ParameterValue=myproject \
               ParameterKey=Environment,ParameterValue=prod
```

### Terraform
```bash
cd terraform/
terraform init
terraform plan -var="project_name=myproject" -var="environment=prod"
terraform apply
```

## Parameters

| Parameter | Description | Default | Allowed Values |
|-----------|-------------|---------|----------------|
| VpcCidr | CIDR block for the VPC | 10.0.0.0/16 | Valid IPv4 CIDR |
| Environment | Environment name | dev | dev, staging, prod |
| ProjectName | Project name for resource naming | myproject | Lowercase letters, numbers, hyphens |

## Outputs

| Output | Description |
|--------|-------------|
| VPC | VPC ID |
| PublicSubnets | List of public subnet IDs |
| PrivateSubnets | List of private subnet IDs |
| DatabaseSubnets | List of database subnet IDs |
| DefaultSecurityGroup | Default security group ID |

## Post-Deployment

1. **Update DNS**: Configure your DNS to point to resources in the new VPC
2. **Security Groups**: Create additional security groups as needed for your applications
3. **Network ACLs**: Configure Network ACLs if additional network-level security is required
4. **VPC Endpoints**: Add VPC endpoints for AWS services to reduce NAT Gateway costs

## Cost Considerations

- **NAT Gateways**: ~$45/month per NAT Gateway + data processing charges
- **VPC Flow Logs**: CloudWatch Logs storage and ingestion costs
- **Elastic IPs**: Free when attached to running instances

## Security Considerations

- Default security group allows traffic only within the security group
- Database subnets have no internet access
- VPC Flow Logs capture all network traffic for monitoring
- Consider enabling GuardDuty for additional threat detection