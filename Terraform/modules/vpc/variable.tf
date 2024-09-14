variable "vpc_cidr_range" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "azs" {
 type        = list(string)
 description = "List of availability zones."
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values."
}
 
variable "app_private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values for applications."
}

variable "db_private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values for DBs specifically."
}

variable "env" {
  description = "Name of the environment like Dev, Test, Staging or Production."
  type        = string
}

variable "owner" {
  description = "Owner of the Application."
  type        = string
}

variable "region_shortcode" {
  description = "Region shortcode of the AWS."
  type        = string
}

variable "eks_name" {
  description = "Name of the EKS cluster."
  type        = string
}