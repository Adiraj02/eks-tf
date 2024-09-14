module "region_shortcode" {
    source = "../modules/region_shortcode"
}

locals {
  region_shortcode       = module.region_shortcode.region_shortcode
  region_shortcode_alpha = module.region_shortcode.region_shortcode_alpha
  eks_name               = "${lower(var.owner)}-eks-${lower(local.region_shortcode)}-${lower(var.env)}"
  eks_version            = "1.30"
  eks_role_name          = "${lower(var.owner)}-eks-cluster-${lower(local.region_shortcode)}-${lower(var.env)}"
  node_group_name        = "${lower(var.owner)}-eks-node-${lower(local.region_shortcode)}-${lower(var.env)}"
  worker_role_name       = "${lower(var.owner)}-eks-node-${lower(local.region_shortcode)}-${lower(var.env)}"
  eks_lbc_role_name      = "${lower(var.owner)}-eks-lbc-${lower(local.region_shortcode)}-${lower(var.env)}"
  eks_lbc_policy_name    = "${lower(var.owner)}-eks-lbc-${lower(local.region_shortcode)}-${lower(var.env)}"
}