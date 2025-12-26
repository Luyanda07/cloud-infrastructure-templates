# Variables for Auto Scaling Web Application
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "webapp"
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
  description = "VPC ID where resources will be created. Leave empty to create new VPC."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for VPC (only used if vpc_id is empty)"
  type        = string
  default     = "10.0.0.0/16"
}

# EC2 Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
  
  validation {
    condition = contains([
      "t3.micro", "t3.small", "t3.medium", "t3.large", "t3.xlarge",
      "t2.micro", "t2.small", "t2.medium", "t2.large",
      "m5.large", "m5.xlarge", "m5.2xlarge"
    ], var.instance_type)
    error_message = "Instance type must be a valid EC2 instance type."
  }
}

variable "key_pair_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
  default     = ""
}

# Auto Scaling Configuration
variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 6
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

# Load Balancer Configuration
variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "health_check_path" {
  description = "Health check path for ALB target group"
  type        = string
  default     = "/"
}

variable "alb_log_retention_days" {
  description = "Number of days to retain ALB logs"
  type        = number
  default     = 30
}

# Database Configuration
variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
  
  validation {
    condition     = contains(["mysql", "postgres", "mariadb"], var.db_engine)
    error_message = "Database engine must be mysql, postgres, or mariadb."
  }
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage for autoscaling in GB"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "webapp"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment for RDS"
  type        = bool
  default     = true
}

variable "db_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "db_backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "db_maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot when deleting RDS instance"
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "Enable deletion protection for RDS instance"
  type        = bool
  default     = true
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}