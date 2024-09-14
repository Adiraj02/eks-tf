variable "aws_region" {
    description = "AWS region where resources will be deployed."
    type        = string
}

variable "env" {
    description = "Name of the environment like Dev, Test, Stage or Prod"
    type        = string
}

variable "owner" {
  description = "Owner of the Application."
  type        = string
}

variable "vpc_cidr_range" {
  description = "The CIDR block for the VPC."
  type        = string
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

variable "azs" {
 type        = list(string)
 description = "List of availability zones."
}