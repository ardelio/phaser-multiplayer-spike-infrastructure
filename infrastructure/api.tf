resource "aws_apigatewayv2_api" "websocket_api" {
  name                       = "${local.stack_details.stack_name}-api-${local.stack_details.stack_id}"
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

resource "aws_cloudwatch_log_group" "websocket_api_log_group" {
  name              = "/aws/apigateway/${local.stack_details.stack_name}-api-${local.stack_details.stack_id}"
  retention_in_days = 7
}