resource "aws_cloudfront_origin_access_identity" "web_base_origin_access_identity" {
  comment = "Web base origin access identity"
}

resource "aws_cloudfront_distribution" "web_base_distribution" {
  enabled = true
  aliases = []
  origin {
    origin_id = aws_s3_bucket.web_base_bucket_host.arn
    domain_name = aws_s3_bucket.web_base_bucket_host.bucket_regional_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web_base_origin_access_identity.cloudfront_access_identity_path
    }
  }
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods        = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]
    cached_methods         = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]
    target_origin_id       = aws_s3_bucket.web_base_bucket_host.arn
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    min_ttl = 0
    default_ttl = 600
    max_ttl = 600
  }
  price_class = "PriceClass_All"
  custom_error_response {
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}