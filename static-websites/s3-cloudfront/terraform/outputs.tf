# S3 Bucket outputs
output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.website.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.website.arn
}

output "s3_bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = aws_s3_bucket.website.bucket_domain_name
}

output "s3_bucket_regional_domain_name" {
  description = "S3 bucket regional domain name"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

output "s3_website_endpoint" {
  description = "S3 website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

# CloudFront outputs
output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.website.arn
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront distribution hosted zone ID"
  value       = aws_cloudfront_distribution.website.hosted_zone_id
}

output "cloudfront_status" {
  description = "CloudFront distribution status"
  value       = aws_cloudfront_distribution.website.status
}

# Website URLs
output "website_url" {
  description = "Website URL (CloudFront)"
  value       = "https://${aws_cloudfront_distribution.website.domain_name}"
}

output "custom_domain_urls" {
  description = "Custom domain URLs (if configured)"
  value       = length(var.domain_names) > 0 ? [for domain in var.domain_names : "https://${domain}"] : []
}

# Logging outputs
output "logs_bucket_id" {
  description = "Logs S3 bucket ID"
  value       = aws_s3_bucket.logs.id
}

output "logs_bucket_arn" {
  description = "Logs S3 bucket ARN"
  value       = aws_s3_bucket.logs.arn
}

# Route 53 outputs
output "route53_records" {
  description = "Route 53 record names"
  value       = aws_route53_record.website[*].name
}

# CloudWatch Alarms
output "cloudwatch_alarm_arns" {
  description = "CloudWatch alarm ARNs"
  value = {
    cloudfront_4xx_errors = aws_cloudwatch_alarm.cloudfront_4xx_error_rate.arn
    cloudfront_5xx_errors = aws_cloudwatch_alarm.cloudfront_5xx_error_rate.arn
  }
}

# Origin Access Control
output "origin_access_control_id" {
  description = "CloudFront Origin Access Control ID"
  value       = aws_cloudfront_origin_access_control.website.id
}

# Deployment information
output "deployment_info" {
  description = "Deployment information and next steps"
  value = {
    bucket_name           = aws_s3_bucket.website.id
    cloudfront_url        = "https://${aws_cloudfront_distribution.website.domain_name}"
    upload_command        = "aws s3 sync ./website-files s3://${aws_s3_bucket.website.id}/"
    invalidation_command  = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.website.id} --paths '/*'"
  }
}