# Load Balancer outputs
output "load_balancer_url" {
  description = "Application Load Balancer URL"
  value       = "http://${aws_lb.main.dns_name}"
}

output "load_balancer_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.main.dns_name
}

output "load_balancer_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.main.arn
}

output "load_balancer_zone_id" {
  description = "Application Load Balancer hosted zone ID"
  value       = aws_lb.main.zone_id
}

# Auto Scaling Group outputs
output "autoscaling_group_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.web.name
}

output "autoscaling_group_arn" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.web.arn
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.web.id
}

output "launch_template_latest_version" {
  description = "Launch Template latest version"
  value       = aws_launch_template.web.latest_version
}

# Database outputs
output "database_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "database_port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

output "database_name" {
  description = "Database name"
  value       = aws_db_instance.main.db_name
}

output "database_username" {
  description = "Database master username"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "database_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.main.arn
}

# Security Group outputs
output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "web_security_group_id" {
  description = "Web servers security group ID"
  value       = aws_security_group.web.id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

# S3 Bucket outputs
output "assets_bucket_name" {
  description = "S3 bucket name for application assets"
  value       = aws_s3_bucket.assets.id
}

output "assets_bucket_arn" {
  description = "S3 bucket ARN for application assets"
  value       = aws_s3_bucket.assets.arn
}

output "alb_logs_bucket_name" {
  description = "S3 bucket name for ALB logs"
  value       = aws_s3_bucket.alb_logs.id
}

# IAM outputs
output "ec2_role_arn" {
  description = "EC2 IAM role ARN"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  description = "EC2 instance profile name"
  value       = aws_iam_instance_profile.ec2_profile.name
}

# VPC outputs
output "vpc_id" {
  description = "VPC ID"
  value       = var.vpc_id != "" ? var.vpc_id : module.vpc[0].vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = var.vpc_id != "" ? data.aws_subnets.public[0].ids : module.vpc[0].public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = var.vpc_id != "" ? data.aws_subnets.private[0].ids : module.vpc[0].private_subnets
}

# Secrets Manager outputs
output "db_credentials_secret_arn" {
  description = "Database credentials secret ARN"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "db_credentials_secret_name" {
  description = "Database credentials secret name"
  value       = aws_secretsmanager_secret.db_credentials.name
}

# CloudWatch Alarms
output "cloudwatch_alarm_arns" {
  description = "CloudWatch alarm ARNs"
  value = {
    high_cpu = aws_cloudwatch_alarm.high_cpu.arn
    low_cpu  = aws_cloudwatch_alarm.low_cpu.arn
  }
}

# Target Group outputs
output "target_group_arn" {
  description = "ALB target group ARN"
  value       = aws_lb_target_group.web.arn
}

output "target_group_name" {
  description = "ALB target group name"
  value       = aws_lb_target_group.web.name
}

# Auto Scaling Policy outputs
output "scale_up_policy_arn" {
  description = "Scale up policy ARN"
  value       = aws_autoscaling_policy.scale_up.arn
}

output "scale_down_policy_arn" {
  description = "Scale down policy ARN"
  value       = aws_autoscaling_policy.scale_down.arn
}

# Connection information
output "connection_info" {
  description = "Connection information for the application"
  value = {
    application_url = "http://${aws_lb.main.dns_name}"
    database_endpoint = aws_db_instance.main.endpoint
    ssh_command = var.key_pair_name != "" ? "ssh -i ~/.ssh/${var.key_pair_name}.pem ec2-user@<instance-ip>" : "Use AWS Systems Manager Session Manager for SSH access"
  }
  sensitive = true
}