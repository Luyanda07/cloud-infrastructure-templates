# RDS Instance outputs
output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.main.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.main.arn
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "db_instance_hosted_zone_id" {
  description = "RDS instance hosted zone ID"
  value       = aws_db_instance.main.hosted_zone_id
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

output "db_instance_name" {
  description = "RDS instance database name"
  value       = aws_db_instance.main.db_name
}

output "db_instance_username" {
  description = "RDS instance master username"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "db_instance_engine" {
  description = "RDS instance engine"
  value       = aws_db_instance.main.engine
}

output "db_instance_engine_version" {
  description = "RDS instance engine version"
  value       = aws_db_instance.main.engine_version
}

output "db_instance_class" {
  description = "RDS instance class"
  value       = aws_db_instance.main.instance_class
}

output "db_instance_status" {
  description = "RDS instance status"
  value       = aws_db_instance.main.status
}

output "db_instance_multi_az" {
  description = "RDS instance Multi-AZ deployment status"
  value       = aws_db_instance.main.multi_az
}

output "db_instance_availability_zone" {
  description = "RDS instance availability zone"
  value       = aws_db_instance.main.availability_zone
}

# Read Replicas
output "read_replica_endpoints" {
  description = "RDS read replica endpoints"
  value       = aws_db_instance.read_replica[*].endpoint
  sensitive   = true
}

output "read_replica_ids" {
  description = "RDS read replica IDs"
  value       = aws_db_instance.read_replica[*].id
}

output "read_replica_arns" {
  description = "RDS read replica ARNs"
  value       = aws_db_instance.read_replica[*].arn
}

# Security
output "db_security_group_id" {
  description = "Security group ID for RDS instance"
  value       = aws_security_group.rds.id
}

output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = var.vpc_id != "" ? aws_db_subnet_group.main[0].name : module.vpc[0].database_subnet_group
}

# KMS
output "kms_key_id" {
  description = "KMS key ID for RDS encryption"
  value       = aws_kms_key.rds.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN for RDS encryption"
  value       = aws_kms_key.rds.arn
}

# Secrets Manager
output "db_credentials_secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "db_credentials_secret_name" {
  description = "Name of the Secrets Manager secret containing database credentials"
  value       = aws_secretsmanager_secret.db_credentials.name
}

# Parameter and Option Groups
output "db_parameter_group_name" {
  description = "DB parameter group name"
  value       = aws_db_parameter_group.main.name
}

output "db_option_group_name" {
  description = "DB option group name"
  value       = aws_db_option_group.main.name
}

# Monitoring
output "enhanced_monitoring_role_arn" {
  description = "Enhanced monitoring IAM role ARN"
  value       = aws_iam_role.enhanced_monitoring.arn
}

# CloudWatch Alarms
output "cloudwatch_alarm_arns" {
  description = "CloudWatch alarm ARNs"
  value = {
    cpu_utilization    = aws_cloudwatch_alarm.database_cpu.arn
    database_connections = aws_cloudwatch_alarm.database_connections.arn
    free_storage_space = aws_cloudwatch_alarm.database_free_storage.arn
    read_latency      = aws_cloudwatch_alarm.database_read_latency.arn
    write_latency     = aws_cloudwatch_alarm.database_write_latency.arn
  }
}

# VPC Information
output "vpc_id" {
  description = "ID of the VPC where RDS is deployed"
  value       = var.vpc_id != "" ? var.vpc_id : module.vpc[0].vpc_id
}

output "database_subnets" {
  description = "List of database subnet IDs"
  value       = var.vpc_id != "" ? data.aws_subnets.database[0].ids : module.vpc[0].database_subnets
}

# Connection Information
output "connection_string" {
  description = "Database connection string (without password)"
  value       = "${aws_db_instance.main.engine}://${aws_db_instance.main.username}@${aws_db_instance.main.endpoint}:${aws_db_instance.main.port}/${aws_db_instance.main.db_name}"
  sensitive   = true
}

# JDBC URL (for Java applications)
output "jdbc_url" {
  description = "JDBC connection URL"
  value       = "jdbc:${aws_db_instance.main.engine}://${aws_db_instance.main.endpoint}:${aws_db_instance.main.port}/${aws_db_instance.main.db_name}"
  sensitive   = true
}

# Read replica connection strings
output "read_replica_connection_strings" {
  description = "Read replica connection strings"
  value = [
    for replica in aws_db_instance.read_replica :
    "${replica.engine}://${replica.username}@${replica.endpoint}:${replica.port}/${replica.db_name}"
  ]
  sensitive = true
}

# Backup Information
output "backup_retention_period" {
  description = "Backup retention period"
  value       = aws_db_instance.main.backup_retention_period
}

output "backup_window" {
  description = "Backup window"
  value       = aws_db_instance.main.backup_window
}

output "maintenance_window" {
  description = "Maintenance window"
  value       = aws_db_instance.main.maintenance_window
}