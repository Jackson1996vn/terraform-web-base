data "archive_file" "lambda_zip" {
  type = "zip"
  source_dir  = "${path.module}/../api/dist"
  output_path = "${path.module}/../api/dist.zip"
}

resource "aws_lambda_function" "web_base_lambda_function" {
  function_name = local.configurations.webBaseFunctionName
  runtime = "nodejs18.x"
  handler = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role = aws_iam_role.system_assume_role.arn
  filename = "../api/dist.zip"
  memory_size = 512
  timeout = 120
  vpc_config {
    security_group_ids = [
      aws_security_group.web_base_security_group.id
    ]
    subnet_ids         = [
      aws_subnet.web_base_system_subnet1.id,
      aws_subnet.web_base_system_subnet2.id,
      aws_subnet.web_base_system_subnet3.id
    ]
  }
  environment {
    variables = {
      PORT = 5000
      REGION = local.configurations.region
      BUCKET_NAME = local.configurations.bucketStorageName
    }
  }
  depends_on = [
    aws_vpc.web_base_system_vpc,
    aws_subnet.web_base_system_subnet1,
    aws_subnet.web_base_system_subnet2,
    aws_subnet.web_base_system_subnet3,
    aws_security_group.web_base_security_group
  ]
}

resource "aws_lambda_permission" "web_base_function_permission_api_gateway" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.web_base_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.web_base_rest_api.execution_arn}/*/*"
}


