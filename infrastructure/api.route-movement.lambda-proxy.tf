resource "aws_iam_role" "role_for_movement_route_proxy" {
  name = "${local.stack_name_prefix}-role-for-movement-route-proxy-${local.stack_id}"

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

resource "aws_lambda_function" "movement_route_proxy" {
  filename         = "../.package/package.zip"
  function_name    = "${local.stack_name_prefix}-movement-route-proxy-${local.stack_id}"
  handler          = "proxies/movement/index.handler"
  role             = aws_iam_role.role_for_movement_route_proxy.arn
  source_code_hash = filebase64sha256("../.package/package.zip")

  runtime = "nodejs12.x"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${local.stack_name_prefix}-movement-route-proxy-${local.stack_id}"
  retention_in_days = 7
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.role_for_movement_route_proxy.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}