# EKS Cluster outputs
output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.main.arn
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  value       = aws_eks_cluster.main.version
}

output "cluster_platform_version" {
  description = "Platform version for the EKS cluster"
  value       = aws_eks_cluster.main.platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster"
  value       = aws_eks_cluster.main.status
}

# OIDC Provider
output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.cluster.arn
}

# Security Groups
output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.cluster.id
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by EKS"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

# Node Groups
output "node_groups" {
  description = "EKS node groups"
  value = {
    for k, v in aws_eks_node_group.main : k => {
      arn           = v.arn
      status        = v.status
      capacity_type = v.capacity_type
      instance_types = v.instance_types
      ami_type      = v.ami_type
      node_group_name = v.node_group_name
      scaling_config = v.scaling_config
    }
  }
}

# VPC Information
output "vpc_id" {
  description = "ID of the VPC where the cluster is deployed"
  value       = var.vpc_id != "" ? var.vpc_id : module.vpc[0].vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = var.vpc_id != "" ? data.aws_vpc.existing[0].cidr_block : module.vpc[0].vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = var.vpc_id != "" ? data.aws_subnets.private[0].ids : module.vpc[0].private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = var.vpc_id != "" ? data.aws_subnets.public[0].ids : module.vpc[0].public_subnets
}

# IAM Roles
output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.cluster.name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = aws_iam_role.cluster.arn
}

output "node_groups_iam_role_name" {
  description = "IAM role name associated with EKS node groups"
  value       = aws_iam_role.node_group.name
}

output "node_groups_iam_role_arn" {
  description = "IAM role ARN associated with EKS node groups"
  value       = aws_iam_role.node_group.arn
}

output "aws_load_balancer_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller"
  value       = aws_iam_role.aws_load_balancer_controller.arn
}

# KMS
output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = aws_kms_key.eks.arn
}

output "kms_key_id" {
  description = "The globally unique identifier for the KMS key"
  value       = aws_kms_key.eks.key_id
}

# CloudWatch
output "cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group for EKS cluster logs"
  value       = aws_cloudwatch_log_group.cluster.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of cloudwatch log group for EKS cluster logs"
  value       = aws_cloudwatch_log_group.cluster.arn
}

# Add-ons
output "cluster_addons" {
  description = "Map of attribute maps for all EKS cluster addons enabled"
  value = {
    vpc-cni           = aws_eks_addon.vpc_cni
    coredns          = aws_eks_addon.coredns
    kube-proxy       = aws_eks_addon.kube_proxy
    aws-ebs-csi-driver = aws_eks_addon.ebs_csi
  }
}

# kubectl config command
output "kubectl_config_command" {
  description = "kubectl config command to connect to the cluster"
  value       = "aws eks update-kubeconfig --region ${data.aws_region.current.name} --name ${aws_eks_cluster.main.name}"
}