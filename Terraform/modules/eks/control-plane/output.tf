output "id" {
  description = "Name of the cluster."
  value       = aws_eks_cluster.eks.id
}

output "name" {
  description = "Name of the cluster."
  value       = aws_eks_cluster.eks.name
}

output "endpoint" {
  description = "Endpoint for your Kubernetes API server."
  value       = aws_eks_cluster.eks.endpoint
}