INFORMATION IN REMAOTE STATE STORAGE UNDER

terraform {
  required_version = "~> 1.0" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Provider Block
provider "aws" {
  region  = "us-west-1"
  profile = "Kenmak"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "bootcamp32-50-ken"     #name of d s3 bucket.
    key    = "vpc/terraform.tfstate"  #i want to read d statefile inside this vpc/ that was created in d s3 bucket.
    region = "us-west-1"            #this is where d bucket was created.Check region in variable.tf. i need to confirm.
  }
}

/*data "terraform_remote_state" "network" {
  backend = "local"
  config = {
      path    = "../remote-data-source/terraform.tfstate"
  }
}*/

resource "aws_instance" "my-ec2" { &&&&&
  ami           = data.aws_ami.amzlinux2.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.public_subnets[1]

  tags = {
    "Name" = "My_ec2"
  }
}

Supplose u are asked to change d nameing convention of d above instance- my-ec2
this is d name that terra knows bc it is d one in d statefile.
do
terraform state list
aws_instance.my-ec2   this is d name captured in aws statefile.
supose u want to change d neame to say dev
if u change it here &&&&&, and u run terraform plan
terrform is going to destroy aws_instance.my-ec2
and will recreate a new instance aws_instance.dev.

but this is not what we want, we want our instance to continue running.
so what do we do?
Terraform has a moved block to move resource without altering d statefile.

moved { 
  from = aws_instance.my-ec2
  to   =   aws_instance.dev
}
u can move it to a module. barely say to = module ec2 name

Terra best practices  BL 2min to end.





d explanation here is for remotedatasource in remote state state storage.


terraform {
  required_version = "~> 1.0" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Provider Block
provider "aws" {
  region  = "us-west-1"
 # profile = "Kenmak"
}

data "terraform_remote_state" "network" {         #from this datasource, i want to look at d output from that statefile, 
  backend = "s3"                                  #there is an output called public_subnets[1] and i want d 2nd subnet(check under)
  config = {
    bucket = "bootcamp32-50-ken"
    key    = "vpc/terraform.tfstate"   
    region = "us-west-1"  #change to region where d vpc is (check variable file)
  }
}

/*data "terraform_remote_state" "network" { *****
  backend = "local"
  config = {
      path    = "../../backend/terraform.tfstate"
  }
}*/

resource "aws_instance" "my-ec2" {            #When i read d statefile, i want to create this instance in a certain Pub subnet
  ami           = data.aws_ami.amzlinux2.id        #  from d vpc module just created. using d datasource above to access this subnet
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.public_subnets[1]  #reading this data to get my subnet id to provision d instance.
                                                                           #i cna provision this instance in a private_subnet, bc i have an 
  tags = {                                                                    output called private.
    "Name" = "My_ec2"
  }
}

go and check ur terraform apply information, u will see 2 output for subnet, from above we want d 2nd subnet.
so this intance my-ec2 will be created in a vpc that already exist in d public subnet.

cd remote-state-data-source
ls
ami-datasource.tf
remote-ec2.tf

goto remote-ec2.tf and rmove proile from provider block  bl 17.33
this d bucket is not lpassed here, this instance my-ec2 is going to be local.


***** if i was going to read this backend, this is how i will reference it it.
I am interested to read d statefile in d backend dir from here.
if i had initialize d vpc as local (creating a local statefile) then i will use this datasource, to provision this instance

so these are d 2 types of data sources that we can use, one is local and the other one is remote (ie s3 w is just a state storage).




