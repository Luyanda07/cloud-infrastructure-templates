# Contributing to AWS Infrastructure Templates

Thank you for your interest in contributing to this project! This document provides guidelines for contributing new templates and improvements.

## 🎯 Template Standards

All templates must follow these standards:

### AWS Well-Architected Framework
Templates must demonstrate compliance with the six pillars:
- **Security**: IAM roles, encryption, network security
- **Reliability**: Multi-AZ, backup strategies, fault tolerance
- **Performance Efficiency**: Right-sizing, caching, monitoring
- **Cost Optimization**: Reserved instances, auto-scaling, lifecycle policies
- **Operational Excellence**: Monitoring, logging, automation
- **Sustainability**: Efficient resource utilization

### Template Requirements
- ✅ **Both Formats**: Provide CloudFormation (YAML/JSON) AND Terraform versions
- ✅ **Documentation**: Include comprehensive README.md
- ✅ **Parameters**: Use configurable parameters with validation
- ✅ **Outputs**: Provide useful outputs for integration
- ✅ **Tagging**: Implement consistent tagging strategy
- ✅ **Security**: Follow security best practices
- ✅ **Testing**: Include deployment instructions

## 📁 Directory Structure

```
templates/
├── category/
│   └── template-name/
│       ├── README.md
│       ├── cloudformation/
│       │   ├── template.yaml
│       │   └── template.json
│       └── terraform/
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           └── versions.tf
```

## 🔄 Contribution Process

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/new-template`
3. **Add** your template following the directory structure
4. **Test** your template in a development environment
5. **Document** your template with a comprehensive README
6. **Commit** your changes with descriptive messages
7. **Push** to your fork: `git push origin feature/new-template`
8. **Create** a Pull Request

## 📝 Template Categories

Current categories:
- **Networking**: VPCs, subnets, routing, security groups
- **Web Applications**: Load balancers, auto scaling, web servers
- **Serverless**: Lambda, API Gateway, Step Functions
- **Containers**: EKS, ECS, Fargate
- **Static Websites**: S3, CloudFront, Route 53
- **Databases**: RDS, DynamoDB, ElastiCache
- **Security**: IAM, KMS, Secrets Manager
- **Monitoring**: CloudWatch, X-Ray, Config

## ✅ Pull Request Checklist

- [ ] Template follows directory structure
- [ ] Both CloudFormation and Terraform versions provided
- [ ] README.md includes all required sections
- [ ] Parameters have proper validation
- [ ] Resources are properly tagged
- [ ] Security best practices followed
- [ ] Template tested in development environment
- [ ] Documentation is clear and comprehensive

## 📋 README Template

Each template README should include:

```markdown
# Template Name

Brief description of what the template creates.

## Architecture
- Component 1: Description
- Component 2: Description

## Well-Architected Framework Compliance
### Security
- Security feature 1
- Security feature 2

### Reliability
- Reliability feature 1
- Reliability feature 2

## Usage
### CloudFormation
```bash
aws cloudformation create-stack ...
```

### Terraform
```bash
terraform init
terraform apply
```

## Parameters
| Parameter | Description | Default | Allowed Values |

## Outputs
| Output | Description |

## Post-Deployment
Steps to complete after deployment

## Cost Considerations
Expected costs and optimization tips

## Security Considerations
Security best practices and considerations
```

## 🐛 Bug Reports

When reporting bugs:
1. Use the issue template
2. Include template name and version
3. Provide error messages and logs
4. Include steps to reproduce
5. Specify AWS region and account type

## 💡 Feature Requests

For new template requests:
1. Describe the use case
2. Explain the architecture needed
3. List required AWS services
4. Provide any reference materials

## 📞 Getting Help

- **Issues**: Use GitHub Issues for bugs and feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Security**: Email security@yourorg.com for security issues

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.