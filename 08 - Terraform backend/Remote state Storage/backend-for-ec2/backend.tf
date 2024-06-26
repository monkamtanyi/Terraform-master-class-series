terraform {
  required_version = "~> 1.2" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


  backend "s3" {
    bucket = "bootcamp32-79-ken"    #this is d bucket we created locally
    key    = "dev/terraform.tfstate"  #dev is like d directory where we want to store our statefile - terraform.tfstate
    dynamodb_table = "terraform-lock"   #it is good to pass this key (dev) for d dir, since i want to store multiple statefile
    region = "us-west-2"

  }
}

# Provider Block
provider "aws" {
  region = "us-west-2"
}

to check what is in d statefile run: terraform state list

monka@DESKTOP-0PEDM4P MINGW64 ~/terra today/Project-03/backend (master)
$ terraform state list
aws_dynamodb_table.tf_lock   # d name of d locke was terraform-lock
aws_kms_key.mykey
aws_s3_bucket.backend[0]
aws_s3_bucket_server_side_encryption_configuration.backend   
aws_s3_bucket_versioning.versioning_example
random_integer.s3

terraform init
Initializing backend
Successfully configured d be "s3"!  terra will use this be unless d be configuration changes.
so this back end has been created.

when u run d terraform apply it creates d ec2 instance desired
when it finishes, it releases d state log. when it was provisioning d log was on.
goto inside d bucket- u see d dev dir createde.
if u click on it u have d terraform.tfstate file.
click on it and open, it shows d statefile (w is inside d dir dev). this statefile is 4 this ec2 instance i just created.
this bucket has been used to store my statefile.
u will not see a statefile in d directory.

In this backend we have a vpc module. go there to continue.

Terraform-master-class-series/08 - Terraform backend/Remote state Storage/vpc-module-backend/01-backend.tf













