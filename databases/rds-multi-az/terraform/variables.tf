# Variables for RDS Multi-AZ configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "myproject"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# Network Configuration
variable "vpc_id" {
  description = "VPC ID where RDS will be created. Leave empty to create new VPC."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for VPC (only used if vpc_id is empty)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# Database Configuration
variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
  
  validation {
    condition     = contains(["mysql", "postgres", "mariadb"], var.engine)
    error_message = "Engine must be one of: mysql, postgres, mariadb."
  }
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "major_engine_version" {
  description = "Major engine version for option group"
  type        = string
  default     = "8.0"
}

variable "parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "mysql8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
  default     = "myapp"
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

# Storage Configuration
variable "allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage for autoscaling in GB"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp3"
  
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.storage_type)
    error_message = "Storage type must be one of: gp2, gp3, io1, io2."
  }
}

# Backup Configuration
variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

# Read Replicas
variable "read_replica_count" {
  description = "Number of read replicas to create"
  type        = number
  default     = 1
}

variable "read_replica_instance_class" {
  description = "Instance class for read replicas"
  type        = string
  default     = "db.t3.micro"
}

# Security Configuration
variable "publicly_accessible" {
  description = "Whether the database should be publicly accessible"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting"
  type        = bool
  default     = false
}

# Monitoring Configuration
variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = true
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention period in days"
  type        = number
  default     = 7
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["error", "general", "slow_query"]
}

# Maintenance Configuration
variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

# Alarm Configuration
variable "alarm_actions" {
  description = "List of ARNs to notify when alarm triggers"
  type        = list(string)
  default     = []
}

variable "max_connections_threshold" {
  description = "Threshold for max connections alarm"
  type        = number
  default     = 80
}

# Database Parameters
variable "db_parameters" {
  description = "List of database parameters to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "innodb_buffer_pool_size"
      value = "{DBInstanceClassMemory*3/4}"
    },
    {
      name  = "max_connections"
      value = "100"
    },
    {
      name  = "slow_query_log"
      value = "1"
    },
    {
      name  = "long_query_time"
      value = "2"
    }
  ]
}

# Database Options
variable "db_options" {
  description = "List of database options to apply"
  type = list(object({
    option_name = string
    option_settings = list(object({
      name  = string
      value = string
    }))
  }))
  default = []
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}