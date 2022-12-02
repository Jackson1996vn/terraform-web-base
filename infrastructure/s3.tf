resource "aws_s3_bucket" "web_base_bucket_storage" {
  bucket = "${local.configurations.bucketStorageName}-${terraform.workspace}"
}

resource "aws_s3_bucket_acl" "web_base_bucket_storage_acl" {
  bucket = aws_s3_bucket.web_base_bucket_storage.id
  acl = "private"
}

resource "aws_s3_bucket" "web_base_bucket_host" {
  bucket = "${local.configurations.bucketHostName}-${terraform.workspace}"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "web_base_bucket_host_acl" {
  bucket = aws_s3_bucket.web_base_bucket_host.id
  acl = "private"
}

resource "aws_s3_bucket_website_configuration" "web_base_bucket_host_setting" {
  bucket = aws_s3_bucket.web_base_bucket_host.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "web_base_policy_distribution_s3" {
  bucket = aws_s3_bucket.web_base_bucket_host.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.web_base_origin_access_identity.iam_arn
        }
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.web_base_bucket_host.arn}/*"
        ]
      }
    ]
  })
}
