resource "random_string" "stack_id" {
  length  = 8
  special = false
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = "ap-southeast-2"
  stack_details = {
    stack_id          = lower(random_string.stack_id.result)
    stack_name        = "phaser-multiplayer-spike"
    stack_name_prefix = "pms"
  }
  tags = {
    Application : local.stack_details.stack_name
    StackID : local.stack_details.stack_id
  }
}