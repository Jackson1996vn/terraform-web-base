resource "aws_iam_role" "system_assume_role" {
  name = "system_assume_role_${terraform.workspace}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
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
          "arn:aws:logs:${local.configurations.region}:${local.configurations.accountId}:log-group:/aws/lambda/${local.configurations.webBaseFunctionName}:*",
          "arn:aws:ec2:${local.configurations.region}:${local.configurations.accountId}:*/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "system_role_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.system_assume_role.name
}