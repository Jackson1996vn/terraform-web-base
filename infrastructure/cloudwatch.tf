resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${local.configurations.webBaseFunctionName}"
  retention_in_days = 0
}

resource "aws_cloudwatch_log_group" "api_gateway_logs_group" {
  name = "/aws/api_gw/${aws_api_gateway_rest_api.web_base_rest_api.id}"
  retention_in_days = 30
  depends_on = [
    aws_api_gateway_rest_api.web_base_rest_api
  ]
}
