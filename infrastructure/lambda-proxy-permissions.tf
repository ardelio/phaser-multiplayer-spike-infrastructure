resource "aws_iam_policy" "lambda_execute_api" {
  name        = "${local.stack_details.stack_name_prefix}-lambda-execute-api-${local.stack_details.stack_id}"
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

resource "aws_iam_policy" "lambda_players_db_read" {
  name        = "${local.stack_details.stack_name_prefix}-lambda-players-db-read-${local.stack_details.stack_id}"
  path        = "/"
  description = "IAM policy for reading the players DB from lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PlayersDbRead",
    "Effect": "Allow",
    "Action": [
        "dynamodb:BatchGet*",
        "dynamodb:DescribeTable",
        "dynamodb:Get*",
        "dynamodb:Query"
    ],
    "Resource": "${aws_dynamodb_table.players.arn}"
  }]
}
EOF
}

resource "aws_iam_policy" "lambda_players_db_write" {
  name        = "${local.stack_details.stack_name_prefix}-lambda-players-db-write-${local.stack_details.stack_id}"
  path        = "/"
  description = "IAM policy for mutating the players DB from lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PlayersDbWrite",
    "Effect": "Allow",
    "Action": [
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