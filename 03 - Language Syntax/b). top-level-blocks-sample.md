# Terraform 10 high level blocks

## Block-1: **Terraform Settings Block**
```
#optional, if u don't provide, then it result to default, where version is latest.
recommended to use the latest version.
Use this block when u want to provide a specific version of terraform to use.

terraform {     #1.0.0 major, minor and patched version. only d most right value can vary.
  required_version = "~> 1.0" #1.1.4/5/6/7   1.2/3/4/5 1.1.4/5/6/7
  required_providers {          #in most cases we constraint d version to d major value
    aws = {                          #ie 1.0
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```u
if i need to pass a specific version of terra, then i will need to  pass my terra settings block.
if u go to aws as a provider (ie reg), u will see d source and latest version., 
Providers hashicorp aws Latest Version



## Block-2: **Provider Block**
```
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = "us-west-2" #optional. will provision in d default region were u are wking
}
when u do aws configure, it sets a d default region. if u don't pass a specific region, above
it sets d default region as ur wking region. if u don't pass any credential it uses 
your default credential w is passed during aws configure.
thus a code like this 

provider "aws" {}  means i am using my default credentials and region.
```

## Block-3: **Resource Block**   creates ur resource. 2 labels req (these are d labels
captured in d statefile) ie resource_typ, eresource_name. then d aguements.
```
resource "aws_instance" "inst1" {
  ami           = "ami-0e5b6b6a9f3db6db8" # Amazon Linux
  instance_type = var.instance_type
}

if asked to provision a vpc, goto reg, search aws_vpc left corner
if u want to create vpc, check in d resource section. but if i have already created and y want 
to get maybe d value check in d data source section.

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"    #one agument req plus d resource type and resource name
}
if u want to add agument scroll down to d aguement section. most are optional.

```

## Block-4: **Input Variables Block**
this gives us an input, use a variable block to pass values into ur resources.
variable blk expects 1 label= name of d var. give it any name that is unique to terra.
But d naming convention shld be able to guide another colleague to understand what
u are doing. eg if i am passing a var for an instance, i can name it instance_type-
so by looking at it u know what is being passed = instance_type
this var block req a type= ie string, number, boolean etc.
```
variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 Instance Type"
  type        = string
}
```

## Block-5: **Output Values Block**  use output to get values or attributes out of our resources
```expect 1 label = name of d output.
then d value you are referencing. eg if i want to get d ip address

output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.inst1.public_ip  #access this attribute as already explain
                           #attribute
                            #ie value = resource_type>resource_name.attribute_name
}
```

## Block-6: **Local Values Block**
 - An example to have a bucket name that is a concatenation of an app name and environment name.
```
locals {
  name = "${var.app_name}-${var.environment_name}"
}

bucket_name = local.name
```

## Block-7: **Data sources Block**    if we want to get info from aws 
 - This example is used to get the latest AMI ID for Amazon Linux2 OS
```
data "aws_ami" "amzLinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
```

## Block-8: **Modules Block**
- An example of an AWS EC2 Instance Module from the terraform registry.
```
module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "my-modules-demo"
  instance_count         = 2
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = "t2.micro"
  key_name               = "terraform-key"
  monitoring             = true
  vpc_security_group_ids = ["sg-08b25c5a5bf489ffa"] # Get Default VPC Security Group ID and replace
  subnet_id              = "subnet-4ee95470"        # Get one public subnet id from default vpc and replace
  user_data              = file("apache-install.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Block-9: **Moved Blocks**
```
moved {
  from = "aws_instance.my_ec2"
  to   = "aws_instance.my_new_ec2"
}
```

## Block-10: **Import Blocks**
```
import {
  to = aws_vpc.my_vpc
  id = "vpc-0b37c8c1dd6d9c791"
}

resource "aws_vpc" "my_vpc" {}
```
