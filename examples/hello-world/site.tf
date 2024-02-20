# ------------------------------------------------------------------------------
# S3 Website
# ------------------------------------------------------------------------------
module "site" {
  source  = "registry.terraform.io/SevenPico/s3-website/aws"
  version = "2.0.1"
  context = module.context.self
  depends_on = [
    aws_route53_zone.public
  ]

  acm_certificate_arn                     = module.ssl_certificate.acm_certificate_arn
  cloudfront_access_log_storage_bucket_id = "" //var.cloudfront_access_log_storage_bucket_id
  cors_allowed_origins                    = var.cors_allowed_origins
  geo_restriction_locations               = var.geo_restriction_locations
  parent_zone_id                          = aws_route53_zone.public[0].zone_id
  s3_access_log_storage_bucket_id         = "" //var.s3_access_log_storage_bucket_id
  parent_zone_name                        = ""

  tls_protocol_version = var.tls_protocol_version

  additional_aliases                = []
  cloudfront_access_logging_enabled = false
  deployment_principal_arns         = []
  dns_alias_enabled                 = true
  geo_restriction_type              = "blacklist"
  s3_object_ownership               = "BucketOwnerEnforced"
  waf_enabled                       = true
  default_root_object               = "index.html"
  custom_error_response = [{
    error_caching_min_ttl = 10,
    error_code            = 404,
    response_code         = 404,
    response_page_path    = "/404.html"
  }]
}



