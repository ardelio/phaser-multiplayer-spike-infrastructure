module "connect_route_lambda_proxy" {
  source = "./modules/lambda-proxy"

  environment_variables = {
    DYNAMOD_DB_TABLE_NAME = aws_dynamodb_table.players.id
  }
  name             = "connect"
  default_route    = true
  stack_details    = local.stack_details
  tags             = local.tags
  websocket_api_id = aws_apigatewayv2_api.websocket_api.id
}

resource "aws_iam_role_policy_attachment" "connect_route_lambda_execute_api" {
  role       = module.connect_route_lambda_proxy.role_name
  policy_arn = aws_iam_policy.lambda_execute_api.arn
}

resource "aws_iam_role_policy_attachment" "connect_route_lambda_players_db_read" {
  role       = module.connect_route_lambda_proxy.role_name
  policy_arn = aws_iam_policy.lambda_players_db_read.arn
}

resource "aws_iam_role_policy_attachment" "connect_route_lambda_players_db_write" {
  role       = module.connect_route_lambda_proxy.role_name
  policy_arn = aws_iam_policy.lambda_players_db_write.arn
}