# S3 Static Website with CloudFront

Static website hosting with S3, CloudFront CDN, Route 53 DNS, and SSL certificate. Includes logging and monitoring for optimal performance and security.

## 🏗️ Architecture

This template creates:
- **S3 Bucket** for static website hosting with versioning
- **CloudFront Distribution** for global content delivery
- **Origin Access Control (OAC)** for secure S3 access
- **Route 53 Records** for custom domain support (optional)
- **SSL/TLS Certificate** integration via ACM
- **CloudWatch Monitoring** and alarms
- **Access Logging** for analytics and debugging

## 📋 Prerequisites

- AWS CLI configured with appropriate permissions
- Domain name and Route 53 hosted zone (for custom domains)
- ACM SSL certificate (for HTTPS with custom domains)

## 🚀 Quick Start

### CloudFormation Deployment

```bash
# Clone the repository
git clone https://github.com/Luyanda07/cloud-infrastructure-templates.git
cd cloud-infrastructure-templates/static-websites/s3-cloudfront/cloudformation

# Deploy with default settings
aws cloudformation create-stack \
  --stack-name my-static-website \
  --template-body file://static-website.yaml \
  --parameters \
    ParameterKey=ProjectName,ParameterValue=mysite \
    ParameterKey=Environment,ParameterValue=prod

# Deploy with custom domain
aws cloudformation create-stack \
  --stack-name my-static-website \
  --template-body file://static-website.yaml \
  --parameters \
    ParameterKey=ProjectName,ParameterValue=mysite \
    ParameterKey=Environment,ParameterValue=prod \
    ParameterKey=DomainName,ParameterValue=example.com \
    ParameterKey=Route53HostedZoneId,ParameterValue=Z1234567890ABC \
    ParameterKey=AcmCertificateArn,ParameterValue=arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012
```

### Terraform Deployment

```bash
# Navigate to Terraform directory
cd ../terraform

# Initialize Terraform
terraform init

# Create terraform.tfvars file
cat > terraform.tfvars << EOF
project_name = "mysite"
environment  = "prod"

# Optional: Custom domain configuration
domain_names = ["example.com", "www.example.com"]
route53_zone_id = "Z1234567890ABC"
acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

# CloudFront configuration
cloudfront_price_class = "PriceClass_100"
log_retention_days = 90
EOF

# Deploy
terraform plan
terraform apply
```

## 🔧 Configuration Options

### Basic Configuration
```yaml
# CloudFormation Parameters
ProjectName: mysite
Environment: prod
IndexDocument: index.html
ErrorDocument: error.html
```

```hcl
# Terraform Variables
project_name = "mysite"
environment  = "prod"
index_document = "index.html"
error_document = "error.html"
create_sample_files = true
```

### Custom Domain Setup
```yaml
# CloudFormation
DomainName: example.com
Route53HostedZoneId: Z1234567890ABC
AcmCertificateArn: arn:aws:acm:us-east-1:123456789012:certificate/...
```

```hcl
# Terraform
domain_names = ["example.com", "www.example.com"]
route53_zone_id = "Z1234567890ABC"
acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/..."
```

### CloudFront Optimization
```hcl
# Price classes for cost optimization
cloudfront_price_class = "PriceClass_All"    # Global edge locations
cloudfront_price_class = "PriceClass_200"    # US, Europe, Asia
cloudfront_price_class = "PriceClass_100"    # US, Europe only
```

## 📁 Website Content Upload

### Upload Your Website Files

```bash
# Get bucket name from stack outputs
BUCKET_NAME=$(aws cloudformation describe-stacks \
  --stack-name my-static-website \
  --query 'Stacks[0].Outputs[?OutputKey==`S3BucketName`].OutputValue' \
  --output text)

# Upload website files
aws s3 sync ./website-files s3://$BUCKET_NAME/

# Create CloudFront invalidation
DISTRIBUTION_ID=$(aws cloudformation describe-stacks \
  --stack-name my-static-website \
  --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontDistributionId`].OutputValue' \
  --output text)

aws cloudfront create-invalidation \
  --distribution-id $DISTRIBUTION_ID \
  --paths "/*"
```

### Sample Website Structure
```
website-files/
├── index.html
├── error.html
├── css/
│   └── style.css
├── js/
│   └── app.js
├── images/
│   └── logo.png
└── favicon.ico
```

## 🔐 Security Features

- **Origin Access Control**: Prevents direct S3 access
- **HTTPS Enforcement**: Redirects HTTP to HTTPS
- **Security Headers**: Configurable via CloudFront
- **Access Logging**: Track all requests
- **Encryption**: S3 server-side encryption

## 📊 Monitoring & Analytics

### CloudWatch Metrics
- **Request Count**: Total requests to CloudFront
- **Error Rates**: 4xx and 5xx error percentages
- **Cache Hit Ratio**: CDN efficiency metrics
- **Origin Latency**: S3 response times

### Access Logs Analysis
```bash
# Download CloudFront logs
aws s3 sync s3://$LOGS_BUCKET/cloudfront-logs/ ./logs/

# Analyze top pages
cat logs/*.gz | gunzip | awk '{print $7}' | sort | uniq -c | sort -nr | head -10

# Analyze traffic by country
cat logs/*.gz | gunzip | awk '{print $8}' | sort | uniq -c | sort -nr
```

## 💰 Cost Optimization

### CloudFront Price Classes
- **PriceClass_100**: ~$0.085/GB (US, Europe)
- **PriceClass_200**: ~$0.120/GB (US, Europe, Asia)
- **PriceClass_All**: ~$0.170/GB (Global)

### S3 Storage Classes
```bash
# Configure lifecycle policy for cost optimization
aws s3api put-bucket-lifecycle-configuration \
  --bucket $BUCKET_NAME \
  --lifecycle-configuration file://lifecycle.json
```

### Caching Strategy
```javascript
// Optimize cache headers in your website
// Static assets (CSS, JS, images)
Cache-Control: public, max-age=31536000, immutable

// HTML files
Cache-Control: public, max-age=0, must-revalidate
```

## 🛠️ Advanced Configuration

### Custom Error Pages
```html
<!-- error.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Page Not Found</title>
</head>
<body>
    <h1>404 - Page Not Found</h1>
    <p>The page you're looking for doesn't exist.</p>
    <a href="/">Go Home</a>
</body>
</html>
```

### Security Headers (CloudFront Functions)
```javascript
function handler(event) {
    var response = event.response;
    var headers = response.headers;
    
    headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload'};
    headers['content-type-options'] = { value: 'nosniff'};
    headers['x-frame-options'] = {value: 'DENY'};
    headers['x-xss-protection'] = {value: '1; mode=block'};
    
    return response;
}
```

## 🧪 Testing

### Performance Testing
```bash
# Test website speed
curl -w "@curl-format.txt" -o /dev/null -s "https://example.com"

# Test from multiple locations
for region in us-east-1 eu-west-1 ap-southeast-1; do
  echo "Testing from $region"
  aws cloudfront get-distribution --id $DISTRIBUTION_ID --region $region
done
```

### SSL Certificate Validation
```bash
# Check SSL certificate
openssl s_client -connect example.com:443 -servername example.com

# Test SSL rating
curl -s "https://api.ssllabs.com/api/v3/analyze?host=example.com"
```

## 🔄 Maintenance

### Regular Tasks
```bash
# Update CloudFront cache
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"

# Monitor costs
aws ce get-cost-and-usage \
  --time-period Start=2023-12-01,End=2023-12-31 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE

# Check security
aws s3api get-bucket-policy --bucket $BUCKET_NAME
```

### Backup Strategy
```bash
# Backup website content
aws s3 sync s3://$BUCKET_NAME/ ./backup/$(date +%Y%m%d)/

# Backup CloudFormation template
aws cloudformation get-template --stack-name my-static-website > backup/template.json
```

## 📚 Well-Architected Principles

- **Security**: HTTPS enforcement, OAC, access logging
- **Reliability**: Multi-region CDN, S3 durability
- **Performance**: Global edge locations, caching optimization
- **Cost Optimization**: Appropriate price class, lifecycle policies
- **Operational Excellence**: Infrastructure as Code, monitoring

## 🔗 Related Templates

- [VPC Multi-AZ](../../networking/vpc-multi-az/) - Network foundation
- [Auto Scaling Web App](../../web-applications/auto-scaling-web-app/) - Dynamic applications
- [Serverless API](../../serverless/api-lambda-dynamodb/) - Backend APIs

## 📖 Additional Resources

- [CloudFront Best Practices](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/best-practices.html)
- [S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [Route 53 DNS Configuration](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/)

## 🆘 Troubleshooting

### Common Issues

**CloudFront not serving updated content**
```bash
# Create invalidation
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"

# Check cache headers
curl -I https://example.com
```

**SSL certificate issues**
```bash
# Verify certificate in us-east-1 (required for CloudFront)
aws acm list-certificates --region us-east-1

# Check certificate validation
aws acm describe-certificate --certificate-arn $CERT_ARN --region us-east-1
```

**Route 53 DNS not resolving**
```bash
# Check DNS propagation
dig example.com
nslookup example.com

# Verify Route 53 records
aws route53 list-resource-record-sets --hosted-zone-id $ZONE_ID
```

## 📄 License

This template is released under the MIT License. See [LICENSE](../../../LICENSE) for details.