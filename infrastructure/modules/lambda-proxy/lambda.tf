resource "aws_lambda_function" "lambda_proxy" {
  filename         = "../.package/package.zip"
  function_name    = "${var.stack_details.stack_name_prefix}-lambda-proxy-${var.name}-route-${var.stack_details.stack_id}"
  handler          = "proxies/${var.name}/index.handler"
  role             = aws_iam_role.lambda_proxy_role.arn
  source_code_hash = filebase64sha256("../.package/package.zip")

  environment {
    variables = var.environment_variables
  }

  runtime = "nodejs12.x"
}

resource "aws_cloudwatch_log_group" "lambda_proxy_log_group" {
  name              = "/aws/lambda/${var.stack_details.stack_name_prefix}-lambda-proxy-${var.name}-route-${var.stack_details.stack_id}"
  retention_in_days = 7
}

resource "aws_iam_role" "lambda_proxy_role" {
  name = "${var.stack_details.stack_name_prefix}-lambda-proxy-${var.name}-route-${var.stack_details.stack_id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "LamdbaAssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "logging" {
  name        = "${var.stack_details.stack_name_prefix}-lambda-${var.name}-logging-${var.stack_details.stack_id}"
  path        = "/"
  description = "IAM policy for logging from lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "${aws_cloudwatch_log_group.lambda_proxy_log_group.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "logging" {
  role       = aws_iam_role.lambda_proxy_role.name
  policy_arn = aws_iam_policy.logging.arn
}
