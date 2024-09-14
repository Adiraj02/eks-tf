module "vpc" {
    source                   = "../modules/vpc"
    vpc_cidr_range           = var.vpc_cidr_range
    public_subnet_cidrs      = var.public_subnet_cidrs
    app_private_subnet_cidrs = var.app_private_subnet_cidrs
    db_private_subnet_cidrs  = var.db_private_subnet_cidrs
    owner                    = var.owner
    region_shortcode         = local.region_shortcode
    env                      = var.env
    azs                      = var.azs
    eks_name                 = local.eks_name
}