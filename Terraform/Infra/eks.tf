# EKS Control Plane
module "eks_cluster" {
    source        = "../modules/eks/control-plane"
    eks_name      = local.eks_name
    subnet_ids    = module.vpc.app_private_subnet_ids
    eks_version   = local.eks_version
    eks_role_name = local.eks_role_name
}

# EKS Worker node group
module "eks_worker" {
    source           = "../modules/eks/worker-nodes"
    eks_name         = module.eks_cluster.name
    eks_version      = local.eks_version
    min_size         = 0
    max_size         = 3
    desired_size     = 0
    node_group_name  = local.node_group_name
    subnet_ids       = module.vpc.app_private_subnet_ids
    worker_role_name = local.worker_role_name
    instance_types   = ["t3.small", "t3a.small", "t2.small"]
}

# EKS Pod Identity Addon
resource "aws_eks_addon" "eks_pod_identity" {
  cluster_name  = module.eks_cluster.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.2-eksbuild.2"
}

# EKS Loadbalancer controller
resource "aws_iam_role" "eks_lbc_role" {
  name = local.eks_lbc_role_name
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["sts:AssumeRole", "sts:TagSession"],
      "Principal": {
        "Service": "pods.eks.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "eks_lbc_policy" {
  policy = file("./policies/AWSLoadBalancerController.json")
  name   = local.eks_lbc_policy_name
}

resource "aws_iam_role_policy_attachment" "eks_lbc_role_policy_attachment" {
  policy_arn = aws_iam_policy.eks_lbc_policy.arn
  role       = aws_iam_role.eks_lbc_role.name
}

resource "aws_eks_pod_identity_association" "eks_lbc_pod_identity_association" {
  cluster_name    = module.eks_cluster.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.eks_lbc_role.arn
}

resource "helm_release" "eks_lbc" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.8.2"
  set {
    name  = "clusterName"
    value = module.eks_cluster.name
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "region"
    value = var.aws_region
  }
  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }
  depends_on = [module.eks_worker]
}