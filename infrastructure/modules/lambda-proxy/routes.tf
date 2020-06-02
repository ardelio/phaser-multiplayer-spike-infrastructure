resource "aws_apigatewayv2_route" "route" {
  api_id    = var.websocket_api_id
  route_key = replace(var.name, "-", "_")
  target    = "integrations/${aws_apigatewayv2_integration.route.id}"
}

resource "aws_apigatewayv2_integration" "route" {
  api_id      = var.websocket_api_id
  description = "Lambda Proxy ${var.name} Integration"

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.lambda_proxy.invoke_arn

  credentials_arn = aws_iam_role.lambda_execution.arn
}

resource "aws_apigatewayv2_integration_response" "route" {
  api_id                   = var.websocket_api_id
  integration_id           = aws_apigatewayv2_integration.route.id
  integration_response_key = "/200/"
}

resource "aws_apigatewayv2_route_response" "route" {
  api_id             = var.websocket_api_id
  route_id           = aws_apigatewayv2_route.route.id
  route_response_key = "$default"
}

resource "aws_iam_role" "lambda_execution" {
  name = "${var.stack_details.stack_name_prefix}-lambda-proxy-${var.name}-route-execution-${var.stack_details.stack_id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "ApiGatewayAssumeRole"
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy" "lambda_execution" {
  name = "${var.stack_details.stack_name_prefix}-lambda-proxy-${var.name}-route-execution-${var.stack_details.stack_id}"
  role = aws_iam_role.lambda_execution.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Effect": "Allow",
        "Resource": "${aws_lambda_function.lambda_proxy.arn}",
        "Sid": "ExecuteLambdaProxy"
      }
    ]
  }
  EOF
}