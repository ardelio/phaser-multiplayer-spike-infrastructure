resource "aws_iam_policy" "lambda_logging" {
  name        = "${local.stack_name_prefix}-lambda-logging-${local.stack_id}"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_execute_api" {
  name        = "${local.stack_name_prefix}-lambda-execute-api-${local.stack_id}"
  path        = "/"
  description = "IAM policy for executing api requests from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "execute-api:ManageConnections"
      ],
      "Resource": "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_apigatewayv2_api.websocket_api.id}/dev/POST/@connections/*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_players_db" {
  name        = "${local.stack_name_prefix}-lambda-players-db-${local.stack_id}"
  path        = "/"
  description = "IAM policy for accessing the players DB from lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PlayersReadWrite",
    "Effect": "Allow",
    "Action": [
        "dynamodb:BatchGet*",
        "dynamodb:DescribeTable",
        "dynamodb:Get*",
        "dynamodb:Query",
        "dynamodb:BatchWrite*",
        "dynamodb:Update*",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
    ],
    "Resource": "${aws_dynamodb_table.players.arn}"
  }]
}
EOF
}