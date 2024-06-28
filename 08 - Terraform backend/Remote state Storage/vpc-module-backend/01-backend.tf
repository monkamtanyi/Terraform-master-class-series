this is d backend that these resources is going to be createe.


terraform {
  required_version = "~> 1.0" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }


  backend "s3" {
    bucket         = "bootcamp32-79-ken"  #s3 bucket created remote
    key            = "vpc/terraform.tfstate"      #store d terraform.tfstate in vpc directory.
    dynamodb_table = "terraform-lock"           #use this same terraform-lock or state log created.

    region = "ca-central-1"

  }
}

/*
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraformstate-landmark-buc"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "My terraform-bucket"
    Environment = "Dev"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 3
  write_capacity = 3
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "Terraform Lock Table"
  }
}
*/

# Provider Block
provider "aws" {            # it does not matter where d region is, u can still use it in another region.
  region  =  var.aws_region
 # profile = "Kenmak"
}

goto 02 generic variables.tf












