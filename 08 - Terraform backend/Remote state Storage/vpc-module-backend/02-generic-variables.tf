We are using d official vpc module.
from here goto 03 local-values



# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-west-2"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}
# Business Division
variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "FINANCE"
}
