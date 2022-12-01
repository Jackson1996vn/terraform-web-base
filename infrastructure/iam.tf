resource "aws_iam_role" "system_assume_role" {
  name = "system_assume_role_${terraform.workspace}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
      }
    }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_policy_${terraform.workspace}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "system_role_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.system_assume_role.name
}

resource "aws_iam_role_policy" "api_gateway_cloudwatch_policy" {
  name = "api-gateway-cloudwatch-policy"
  role = aws_iam_role.system_assume_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}