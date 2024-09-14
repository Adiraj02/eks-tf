locals {
  shortener_regex = "^([^-]*)-(.)(?:o[ru]th|[ae]st|entral)(.?)[^-]*-(.*)$"
  region          = data.aws_region.this.name
  numeric_words   = {
    "0" = "zero",
    "1" = "one",
    "2" = "two",
    "3" = "three"
    "4" = "four"
  }
  region_shortcode = join("", regex(local.shortener_regex, local.region))
  region_shortcode_alpha = "${substr(local.region_shortcode, 0, length(local.region_shortcode)-1)}-${lookup(local.numeric_words, tostring(substr(local.region_shortcode, -1, -1)), "default")}"
}