resource "aws_dynamodb_table" "players" {
  name           = "${local.stack_name_prefix}-players-${local.stack_id}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "WorldId"
  range_key      = "ConnectionId"

  attribute {
    name = "WorldId"
    type = "N"
  }

  attribute {
    name = "ConnectionId"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  tags = local.tags
}