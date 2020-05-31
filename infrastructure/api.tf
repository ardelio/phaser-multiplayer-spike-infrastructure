resource "aws_apigatewayv2_api" "websocket_api" {
  name                       = "${local.stack_name}-api-${local.stack_id}"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_stage" "dev_stage" {
  api_id      = aws_apigatewayv2_api.websocket_api.id
  name        = "dev"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.websocket_api_log_group.arn
    format          = jsonencode({ "requestId" : "$context.requestId", "ip" : "$context.identity.sourceIp", "caller" : "$context.identity.caller", "user" : "$context.identity.user", "requestTime" : "$context.requestTime", "eventType" : "$context.eventType", "routeKey" : "$context.routeKey", "status" : "$context.status", "connectionId" : "$context.connectionId" })
  }

  default_route_settings {
    logging_level          = "ERROR"
    throttling_burst_limit = 5
    throttling_rate_limit  = 10
  }

  tags = local.tags
}

resource "aws_iam_role" "lambda_execution" {
  name = "${local.stack_name_prefix}-lambda-execution-role-${local.stack_id}"

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
      "Sid": ""
    }
  ]
}
EOF

  tags = local.tags
}

resource "aws_iam_role_policy" "lambda_execution" {
  name = "${local.stack_name_prefix}-lambda-execution-role-policy-${local.stack_id}"
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
        "Resource": [
          "${aws_lambda_function.connection_id_route_proxy.arn}",
          "${aws_lambda_function.join_game_route_proxy.arn}",
          "${aws_lambda_function.movement_route_proxy.arn}"
        ]
      }
    ]
  }
  EOF
}

resource "aws_cloudwatch_log_group" "websocket_api_log_group" {
  name              = "/aws/apigateway/${local.stack_name}-api-${local.stack_id}"
  retention_in_days = 7
}