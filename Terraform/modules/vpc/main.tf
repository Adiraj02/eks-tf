resource "aws_vpc" "vpc" {
 cidr_block                       = var.vpc_cidr_range
 enable_dns_support               = true
 enable_dns_hostnames             = true
 assign_generated_ipv6_cidr_block = true
 tags       = {
   Name     = "${lower(var.owner)}-vpc-${lower(var.region_shortcode)}-${lower(var.env)}"
 }
}

resource "aws_subnet" "public_subnets" {
 count                           = length(var.public_subnet_cidrs)
 vpc_id                          = aws_vpc.vpc.id
 cidr_block                      = element(var.public_subnet_cidrs, count.index)
 ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, count.index)}"
 availability_zone               = element(var.azs, count.index)
 assign_ipv6_address_on_creation = true
 tags   = {
   Name                                                   = "${lower(var.owner)}-public-subnet-${count.index + 1}-${lower(var.region_shortcode)}-${lower(var.env)}"
   "kubernetes.io/role/elb"                               = "1"
   "kubernetes.io/cluster/${var.eks_name}"                = "owned"
 }
}
 
resource "aws_subnet" "app_private_subnets" {
 count             = length(var.app_private_subnet_cidrs)
 vpc_id            = aws_vpc.vpc.id
 cidr_block        = element(var.app_private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 tags   = {
   Name                                                   = "${lower(var.owner)}-app-private-subnet-${count.index + 1}-${lower(var.region_shortcode)}-${lower(var.env)}"
   "kubernetes.io/role/internal-elb"                      = "1"
   "kubernetes.io/cluster/${var.eks_name}"                = "owned"
 }
}

resource "aws_subnet" "db_private_subnets" {
 count             = length(var.db_private_subnet_cidrs)
 vpc_id            = aws_vpc.vpc.id
 cidr_block        = element(var.db_private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 tags   = {
   Name = "${lower(var.owner)}-db-private-subnet-${count.index + 1}-${lower(var.region_shortcode)}-${lower(var.env)}"
 }
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.vpc.id
 tags   = {
   Name = "${lower(var.owner)}-igw-${lower(var.region_shortcode)}-${lower(var.env)}"
 }
}

resource "aws_route_table" "public_route_table" {
 vpc_id = aws_vpc.vpc.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
 route {
   ipv6_cidr_block = "::/0"
   gateway_id      = aws_internet_gateway.igw.id
 }
 tags   = {
   Name = "${lower(var.owner)}-public-rt-${lower(var.region_shortcode)}-${lower(var.env)}"
 }
}

resource "aws_route_table_association" "public_subnet_association" {
 count          = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = {
    Name = "${lower(var.owner)}-nat-eip-${lower(var.region_shortcode)}-${lower(var.env)}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[1].id
  tags   = {
    Name = "${lower(var.owner)}-nat-${lower(var.region_shortcode)}-${lower(var.env)}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id       = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags         = {
    Name       = "${lower(var.owner)}-private-rt-${lower(var.region_shortcode)}-${lower(var.env)}"
  }
}

resource "aws_route_table_association" "app_private_subnet_association" {
 count          = length(var.app_private_subnet_cidrs)
 subnet_id      = element(aws_subnet.app_private_subnets[*].id, count.index)
 route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "db_private_subnet_association" {
 count          = length(var.db_private_subnet_cidrs)
 subnet_id      = element(aws_subnet.db_private_subnets[*].id, count.index)
 route_table_id = aws_route_table.private_route_table.id
}