terraform {
  backend "s3" {
    bucket  = "phaser-multiplayer-spike-8eqs8mok"
    key     = "terraform/terraform.tfstate"
    region  = "ap-southeast-2"
    encrypt = true
  }
}