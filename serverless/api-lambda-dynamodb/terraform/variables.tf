variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "serverless-api"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "items"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.table_name))
    error_message = "Table name must contain only letters, numbers, underscores, and hyphens."
  }
}

variable "api_stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "v1"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.api_stage_name))
    error_message = "API stage name must contain only letters, numbers, underscores, and hyphens."
  }
}