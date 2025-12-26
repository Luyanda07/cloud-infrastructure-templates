# EKS Cluster with Managed Node Groups

Production-ready Amazon EKS cluster with managed node groups, RBAC, monitoring, and security best practices.

## 🏗️ Architecture

This template creates:
- **EKS Cluster** with encryption at rest and comprehensive logging
- **Managed Node Groups** with auto-scaling capabilities
- **VPC** (optional - can use existing VPC)
- **IAM Roles** with least privilege access
- **Security Groups** with proper network segmentation
- **KMS Key** for secrets encryption
- **CloudWatch Logging** for cluster monitoring
- **EKS Add-ons** (VPC CNI, CoreDNS, kube-proxy, EBS CSI)
- **OIDC Provider** for service account integration

## 📋 Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- kubectl installed
- Helm installed (optional, for additional deployments)

## 🚀 Quick Start

### 1. Clone and Navigate
```bash
git clone https://github.com/Luyanda07/cloud-infrastructure-templates.git
cd cloud-infrastructure-templates/containers/eks-cluster/terraform
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Configure Variables
Create a `terraform.tfvars` file:
```hcl
project_name = "myapp"
environment  = "dev"

# Optional: Use existing VPC
# vpc_id = "vpc-xxxxxxxxx"

# Node group configuration
node_groups = {
  general = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    disk_size      = 20
    desired_size   = 2
    max_size       = 4
    min_size       = 1
  }
  spot = {
    instance_types = ["t3.medium", "t3.large"]
    capacity_type  = "SPOT"
    disk_size      = 20
    desired_size   = 1
    max_size       = 3
    min_size       = 0
  }
}

# Restrict cluster access (recommended for production)
cluster_endpoint_public_access_cidrs = ["YOUR_IP/32"]
```

### 4. Deploy
```bash
terraform plan
terraform apply
```

### 5. Configure kubectl
```bash
aws eks update-kubeconfig --region us-west-2 --name myapp-dev-eks
kubectl get nodes
```

## 🔧 Configuration Options

### Node Groups
Configure multiple node groups for different workload types:
```hcl
node_groups = {
  # General purpose nodes
  general = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    disk_size      = 20
    desired_size   = 2
    max_size       = 4
    min_size       = 1
  }
  
  # Spot instances for cost optimization
  spot = {
    instance_types = ["t3.medium", "t3.large", "t3.xlarge"]
    capacity_type  = "SPOT"
    disk_size      = 20
    desired_size   = 1
    max_size       = 10
    min_size       = 0
  }
  
  # Compute optimized for CPU-intensive workloads
  compute = {
    instance_types = ["c5.large", "c5.xlarge"]
    capacity_type  = "ON_DEMAND"
    disk_size      = 50
    desired_size   = 0
    max_size       = 5
    min_size       = 0
  }
}
```

### VPC Configuration
```hcl
# Create new VPC
vpc_cidr = "10.0.0.0/16"

# Or use existing VPC
vpc_id = "vpc-xxxxxxxxx"
```

### Security
```hcl
# Restrict API server access
cluster_endpoint_public_access_cidrs = ["203.0.113.0/24"]

# Additional workstation access
workstation_cidr_blocks = ["203.0.113.0/24"]
```

## 🔐 Security Features

- **Encryption at Rest**: All secrets encrypted with customer-managed KMS key
- **Network Security**: Private node groups, security group rules
- **IAM Integration**: OIDC provider for service account roles
- **Audit Logging**: Comprehensive cluster logging to CloudWatch
- **Add-on Management**: Managed add-ons with automatic updates

## 📊 Monitoring & Logging

### CloudWatch Integration
- Cluster control plane logs
- Container Insights ready
- Custom metrics namespace

### Accessing Logs
```bash
# View cluster logs
aws logs describe-log-groups --log-group-name-prefix "/aws/eks/myapp-dev-eks"

# Stream logs
aws logs tail /aws/eks/myapp-dev-eks/cluster --follow
```

## 🛠️ Post-Deployment Setup

### 1. Install AWS Load Balancer Controller
```bash
# Add Helm repository
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# Install controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=myapp-dev-eks \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

### 2. Install Cluster Autoscaler
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```

### 3. Install Metrics Server
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

## 💰 Cost Optimization

- **Spot Instances**: Use spot node groups for non-critical workloads
- **Right-sizing**: Start with smaller instances and scale based on usage
- **Auto Scaling**: Automatic scaling based on demand
- **Reserved Instances**: Consider RIs for predictable workloads

## 🔄 Maintenance

### Updating Kubernetes Version
```bash
# Update cluster
terraform apply -var="kubernetes_version=1.29"

# Update node groups (will be recreated)
terraform apply
```

### Updating Add-ons
```bash
# Check available versions
aws eks describe-addon-versions --addon-name vpc-cni

# Update in terraform.tfvars and apply
terraform apply
```

## 🧪 Testing

### Verify Cluster Health
```bash
kubectl get nodes
kubectl get pods --all-namespaces
kubectl top nodes
```

### Deploy Test Application
```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
kubectl get services
```

## 📚 Well-Architected Principles

- **Security**: Encryption, IAM integration, network isolation
- **Reliability**: Multi-AZ deployment, auto-scaling, managed services
- **Performance**: Optimized instance types, monitoring
- **Cost Optimization**: Spot instances, auto-scaling
- **Operational Excellence**: Infrastructure as Code, logging, monitoring

## 🔗 Related Templates

- [VPC Multi-AZ](../../networking/vpc-multi-az/) - Network foundation
- [Auto Scaling Web App](../../web-applications/auto-scaling-web-app/) - Application deployment

## 📖 Additional Resources

- [EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/)
- [EKS Workshop](https://www.eksworkshop.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## 🆘 Troubleshooting

### Common Issues

**Node groups not joining cluster**
```bash
# Check IAM roles and security groups
kubectl get nodes
aws eks describe-cluster --name myapp-dev-eks
```

**Pods stuck in pending**
```bash
# Check node capacity and taints
kubectl describe nodes
kubectl get pods -o wide
```

**Load balancer not working**
```bash
# Verify AWS Load Balancer Controller
kubectl get pods -n kube-system | grep aws-load-balancer-controller
```

## 📄 License

This template is released under the MIT License. See [LICENSE](../../../LICENSE) for details.