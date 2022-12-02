output "web_base_api_endpoint" {
  value = "${aws_api_gateway_stage.web_base_api_gateway_stage.invoke_url}/${local.configurations.healthCheckPath}/"
}

output "web_base_endpoint" {
  value = aws_cloudfront_distribution.web_base_distribution.domain_name
}