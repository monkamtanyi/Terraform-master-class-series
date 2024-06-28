# Define Local Values in Terraform
next goto 04

locals {
  owners      = var.business_division
  environment = var.environment
  name        = "${var.business_division}-${var.environment}"  #d name is a concatination of this business_division and d enviroment
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}
