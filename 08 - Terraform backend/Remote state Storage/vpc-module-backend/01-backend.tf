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

goto 02 generic variables.tf.

when u finish all and apply
goto aws check d created vpc,
then click s3 bucket (bootcamp32-50-ken), we are using same s3 bucket. now u will see vpc/ appearing under dev/ created b4
check here = (amazon s52>buckets>bootcamp32-50-ken)

if u open d vpc/ dir u see d terraform.tfstate file
open d statefile and see d content of our statefile for our vpc.

in a nutshell, in ur e't u will have a vpc like this that is customized as a netwk for ur e't.
Once u have a vpc like this customized for ur e't, u will be creating resources inside of this vpc.

How can we create a resource inside of this vpc.
We our statefile for this vpc module w is inside this s3 bucket, so if i want to create a resource
in this vpc how do i access it. ths is what we call data sources -ds.

u can use d ds to read d statefile.
how do we do that.

goto Terraform-master-class-series/09 - Local and Remote state data sources/remote-state-data-source
/remote-data-source
ie copy remote-data-source dir (Terraform-master-class-series/09 - Local and Remote state data
sources/remote-state-data-source/remote-data-source/    the files are ami-datasource.tf and remote-ec2.tf )
into Remote state Storage dir(Terraform-master-class-series/09 - Local and Remote state data sources
/remote-state-data-source/ ) so that they shld be in one directory in d vscode.

for us to read that statefile, 
take out d profile on remote-ec2.tf
goto d remote-ec2.tf














