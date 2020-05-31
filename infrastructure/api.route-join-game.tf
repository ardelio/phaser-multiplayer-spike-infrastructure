resource "aws_apigatewayv2_route" "join_game_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "join_game"
  target    = "integrations/${aws_apigatewayv2_integration.join_game_route.id}"
}

resource "aws_apigatewayv2_integration" "join_game_route" {
  api_id      = aws_apigatewayv2_api.websocket_api.id
  description = "Lambda Proxy Integration"

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.join_game_route_proxy.invoke_arn

  credentials_arn = aws_iam_role.lambda_execution.arn
}