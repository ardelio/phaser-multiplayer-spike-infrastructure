resource "aws_apigatewayv2_route" "connection_id_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "connection_id"
  target    = "integrations/${aws_apigatewayv2_integration.connection_id_route.id}"
}

resource "aws_apigatewayv2_integration" "connection_id_route" {
  api_id      = aws_apigatewayv2_api.websocket_api.id
  description = "Lambda Proxy Integration"

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.connection_id_route_proxy.invoke_arn

  credentials_arn = aws_iam_role.lambda_execution.arn
}

resource "aws_apigatewayv2_integration_response" "connection_id_route" {
  api_id                   = aws_apigatewayv2_api.websocket_api.id
  integration_id           = aws_apigatewayv2_integration.connection_id_route.id
  integration_response_key = "/200/"
}

resource "aws_apigatewayv2_route_response" "connection_id_route" {
  api_id             = aws_apigatewayv2_api.websocket_api.id
  route_id           = aws_apigatewayv2_route.connection_id_route.id
  route_response_key = "$default"
}