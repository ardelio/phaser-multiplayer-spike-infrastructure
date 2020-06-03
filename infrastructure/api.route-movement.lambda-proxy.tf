module "movement_route_lambda_proxy" {
  source = "./modules/lambda-proxy"

  environment_variables = {
    API_ENDPOINT          = replace(aws_apigatewayv2_stage.dev_stage.invoke_url, "/^wss/", "https")
    DYNAMO_DB_TABLE_NAME = aws_dynamodb_table.connections.id
  }
  name             = "movement"
  stack_details    = local.stack_details
  tags             = local.tags
  websocket_api_id = aws_apigatewayv2_api.websocket_api.id
}

resource "aws_iam_role_policy_attachment" "movement_route_lambda_execute_api" {
  role       = module.movement_route_lambda_proxy.role_name
  policy_arn = aws_iam_policy.lambda_execute_api.arn
}

resource "aws_iam_role_policy_attachment" "movement_route_lambda_connections_db_read" {
  role       = module.movement_route_lambda_proxy.role_name
  policy_arn = aws_iam_policy.lambda_connections_db_read.arn
}