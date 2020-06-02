variable environment_variables {
  default = {
    NULL = "null"
  }
}
variable "name" {}
variable "stack_details" {
  type = object({
    stack_id          = string
    stack_name        = string
    stack_name_prefix = string
  })
}
variable "tags" {}
variable "websocket_api_id" {}
