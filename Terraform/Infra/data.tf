data "aws_eks_cluster" "eks" {
  name = module.eks_cluster.name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks_cluster.name
}