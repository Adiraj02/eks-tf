output "vpc_id" {
  description = "Id of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "CIDR of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet Ids of the VPC"
  value       = aws_subnet.public_subnets[*].id
}

output "app_private_subnet_ids" {
  description = "Application private subnet Ids of the VPC"
  value       = aws_subnet.app_private_subnets[*].id
}

output "db_private_subnet_ids" {
  description = "DB private subnet Ids of the VPC"
  value       = aws_subnet.db_private_subnets[*].id
}