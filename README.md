# AWS Infrastructure Templates

This repository contains curated CloudFormation and Terraform templates for common AWS architectures, built according to AWS Well-Architected Framework principles.

## Template Categories

### Networking
- VPC with Public and Private Subnets
- Multi-AZ VPC with NAT Gateways
- Transit Gateway Hub and Spoke

### Web Applications
- Auto Scaling Web Application
- Application Load Balancer with SSL
- Multi-Tier Web Architecture

### Serverless
- Serverless API with Lambda and DynamoDB
- Event-Driven Architecture
- Serverless Data Processing Pipeline

### Containers
- EKS Cluster with Managed Node Groups
- ECS Fargate Service
- Container CI/CD Pipeline

### Static Websites
- S3 Static Website with CloudFront
- Hugo/Jekyll Static Site Pipeline
- Multi-Environment Static Hosting

### Databases
- RDS Multi-AZ with Read Replicas
- DynamoDB with Global Tables
- Aurora Serverless v2

## Well-Architected Framework Compliance

Each template is designed following the six pillars:

- **Security**: IAM roles, encryption, VPC security groups
- **Reliability**: Multi-AZ deployment, auto-scaling, backup strategies
- **Performance Efficiency**: Right-sized resources, caching, monitoring
- **Cost Optimization**: Reserved instances, auto-scaling, lifecycle policies
- **Operational Excellence**: CloudWatch monitoring, automated deployments
- **Sustainability**: Efficient resource utilization, serverless where appropriate

## Usage

1. Choose the appropriate template for your use case
2. Review the parameters and customize as needed
3. Deploy using AWS CLI, Console, or your preferred IaC tool
4. Follow the post-deployment configuration steps in each template's README

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on contributing new templates.