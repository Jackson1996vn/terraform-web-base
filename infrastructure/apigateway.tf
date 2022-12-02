resource "aws_api_gateway_rest_api" "web_base_rest_api" {
  name        = "Web base rest api"
  description = "Web base rest api"
  endpoint_configuration {
    types = [
      "REGIONAL"
    ]
  }
}

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.system_assume_role.arn
}

resource "aws_api_gateway_resource" "web_base_api_gateway_resource" {
  parent_id   = aws_api_gateway_rest_api.web_base_rest_api.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.web_base_rest_api.id
}

resource "aws_api_gateway_method" "web_base_api_gateway_method" {
  rest_api_id        = aws_api_gateway_rest_api.web_base_rest_api.id
  resource_id        = aws_api_gateway_resource.web_base_api_gateway_resource.id
  http_method        = "ANY"
  authorization      = "NONE"
  #  authorizer_id                 = "${aws_api_gateway_authorizer.custom_authorizer.id}"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "web_base_api_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.web_base_rest_api.id
  resource_id             = aws_api_gateway_resource.web_base_api_gateway_resource.id
  http_method             = aws_api_gateway_method.web_base_api_gateway_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.web_base_lambda_function.invoke_arn
  passthrough_behavior    = "WHEN_NO_MATCH"
  depends_on = [
    aws_api_gateway_method.web_base_api_gateway_method
  ]
}

resource "aws_api_gateway_deployment" "web_base_api_gateway_deployment" {
  depends_on = [
    aws_api_gateway_method.web_base_api_gateway_method
  ]
  rest_api_id = aws_api_gateway_rest_api.web_base_rest_api.id
}

resource "aws_api_gateway_stage" "web_base_api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.web_base_api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.web_base_rest_api.id
  stage_name    = terraform.workspace
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs_group.arn
    format          = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

resource "aws_api_gateway_method_settings" "web_base_api_gateway_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.web_base_rest_api.id
  stage_name  = aws_api_gateway_stage.web_base_api_gateway_stage.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
  }
  depends_on = [
    aws_api_gateway_account.api_gateway_account
  ]
}
