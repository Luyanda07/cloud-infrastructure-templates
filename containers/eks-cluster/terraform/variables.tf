# Variables for EKS cluster configuration
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

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be created. Leave empty to create new VPC."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for VPC (only used if vpc_id is empty)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.28"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks that can access the EKS cluster endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "workstation_cidr_blocks" {
  description = "List of CIDR blocks for workstation access"
  type        = list(string)
  default     = []
}

variable "node_groups" {
  description = "Map of EKS managed node group configurations"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    disk_size      = number
    desired_size   = number
    max_size       = number
    min_size       = number
  }))
  default = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 20
      desired_size   = 2
      max_size       = 4
      min_size       = 1
    }
  }
}

# EKS Add-on versions
variable "vpc_cni_version" {
  description = "Version of the VPC CNI add-on"
  type        = string
  default     = "v1.15.1-eksbuild.1"
}

variable "coredns_version" {
  description = "Version of the CoreDNS add-on"
  type        = string
  default     = "v1.10.1-eksbuild.5"
}

variable "kube_proxy_version" {
  description = "Version of the kube-proxy add-on"
  type        = string
  default     = "v1.28.2-eksbuild.2"
}

variable "ebs_csi_version" {
  description = "Version of the EBS CSI driver add-on"
  type        = string
  default     = "v1.24.0-eksbuild.1"
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}