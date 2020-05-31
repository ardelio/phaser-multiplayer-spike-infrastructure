resource "aws_iam_role" "role_for_connection_id_route_proxy" {
  name = "${local.stack_name_prefix}-role-for-connection-id-route-proxy-${local.stack_id}"

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
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "connection_id_route_proxy" {
  filename         = "../.package/package.zip"
  function_name    = "${local.stack_name_prefix}-connection-id-route-proxy-${local.stack_id}"
  handler          = "proxies/connection-id/index.handler"
  role             = aws_iam_role.role_for_connection_id_route_proxy.arn
  source_code_hash = filebase64sha256("../.package/package.zip")

  runtime = "nodejs12.x"
}

resource "aws_cloudwatch_log_group" "connection_id_route_log_group" {
  name              = "/aws/lambda/${local.stack_name_prefix}-connection-id-route-proxy-${local.stack_id}"
  retention_in_days = 7
}

resource "aws_iam_role_policy_attachment" "connection_id_route_lambda_logs" {
  role       = aws_iam_role.role_for_connection_id_route_proxy.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
