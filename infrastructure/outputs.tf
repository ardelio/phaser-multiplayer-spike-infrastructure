output "websocket_url" {
  value = aws_apigatewayv2_stage.dev_stage.invoke_url
}
