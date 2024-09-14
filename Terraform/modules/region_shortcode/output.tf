output "region_shortcode" {
  value       = local.region_shortcode
  description = "Returns shortcode of the current AWS region. For ex, ap-southeast-1 shortcode will be apse1"
}

output "region_shortcode_alpha" {
  value       = local.region_shortcode_alpha
  description = "Returns shortcode of the current AWS region only in alphabetical form. For ex, ap-southeast-1 shortcode will be apse_one"
}