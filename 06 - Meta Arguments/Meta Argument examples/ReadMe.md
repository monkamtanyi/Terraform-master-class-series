# Terraform Meta-Arguments

- Meta arguments alter the behavior of a resource.
  aguements change d resources, if i change d ami, it will change resource, if i change d instance
  type, i have changed d resource. but meta agument alter d behavior of d resource.

resource "aws_instance" "test_ec2" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.my_instance_type["dev"]
  #user_data     = file("${path.module}/httpd.sh")

  tags = {
    Name = var.my_instance_name
  }
}
#EIP configurations
resource "aws_eip" "my_eip" {
  instance = aws_instance.test_ec2.id
}
this eip is attached to d instance, so it needs d instance id, it depends on d instance.
in terra we call this iimplicit dependency(terra determines w resorce need to be created first). 
meaning that when i make a plan to provision above, resoruce-terraform plan- terra
will plan to create d instance first b4 d eip, because d eip needs d id of d instance. w will be
used to attach it to the instance.

we can have explicit dependency.
means that u as an engr determines w resource needs to be created first.
suppose i want to create an aws_vpc called my_test
d only aguement to pass inside this resource blk is d cidr_block
i want d instance to be created and placed inside this vpc under.
this means i have to put it in a subnet.
i can pass a subnet id on my ec2. but this subnet needs to come from the vpc i am creating.
so how do i get a subnet from this vpc, so this bcomes an attribute
so goto aws_vpc look for attribute reference- can i get a subnet from that vpc as an output?
so try aws_subnet- basic usage= i can create a subnet in a vpc. copy to code.
this subnet wil be inside this vpc. so my vpc_id will be taged with d vpc name my_test
nest how do i get id of subnet-goto attribute ref. i need this id bcos that is where d
instance will be provisioned. pass d subnet id as shown below.

so with this i am creating a vpc with a subnet within that vpc. this instance will be placed
inside this subnet. u see i am not using a default subnet, i am defining where i want my 
instance to be created (explicit...), with this i can say bcos my instance depents on d vpc,
i can instruct terra explicitely by using depends on meta aguement - this depends on
(see under) is justaltering how this resource will be created it is just sayin g that this 
resource has to be created first b4 this.
implicitely d subnet can only be created after d vpc has been created.
i can goto documentation and look for aws_instance resource


#EC2Binstance configurations
resource "aws_instance" "test_ec2" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.my_instance_type["dev"]
  #user_data     = file("${path.module}/httpd.sh")
  #wking with an ubuntu instance i don't need above.

   subnet_id = aws_subnet.main.id
   depends_on = [aws_vpc.my_test]
  tags = {
    Name = var.my_instance_name
  }
}

#EIP configurations
resource "aws_eip" "my_eip" {
  instance = aws_instance.test_ec2.id
}

resource "aws_vpc" "my_test" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.my_test.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}




look at d ordr of creation
aws_vpc.my_test: Creating...
aws_vpc.my_test: Creation complete after 2s [id=vpc-0ab934bfdc6978dc2]
aws_subnet.main: Creating...
aws_subnet.main: Creation complete after 1s [id=subnet-0f10f6dc9f7823f26]
aws_instance.test_ec2: Creating...
aws_instance.test_ec2: Still creating... [10s elapsed]
aws_instance.test_ec2: Still creating... [20s elapsed]
aws_instance.test_ec2: Still creating... [30s elapsed]
aws_instance.test_ec2: Creation complete after 32s [id=i-006bfb1728ef92515]
aws_eip.my_eip: Creating...

check aws   counsel>vpc check vpc created.>select d vpc created>resources map new to see
d subnet just created called main> click on arrow at end for dtails info ie 
vpc>subnet>subnet-Oe1n.../Main
check d subnet id an name in d instance to ensure it correspond to d one created
so hwre we have explicitely decided on how we want our resource created.
we have seen d first meta agument= depends on. meta aguement just alter d 
behavior of how u wqnt d resources to be created.

vpc created first, 2nd subnet 3rd instance- bcos d instance is placed in this subnet.

COUNT
Suppose we want to create more than 1 resources say 2 instance at once. we 
use count.
create a dir called count
copy resource.tf and data.tf into it
count is no. of rsources u wnat to create

if i run terra with say count = 3, how will it differentiate d resources or instances created.
use index. count returns a list [list use square brackets], so count.index is going to 
index d resources.
d 1st obj created will be at index position 0, d 2nd index position 1 and d 3rd index position 2.

resource.tf

#EC2Binstance configurations
resource "aws_instance" "test_ec2" {
  count = 3
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.my_instance_type["dev"]

  tags = {
    Name = "Demo-ec2 {$count.index}"
  }
}

variable.tf

variable "us_region" {
  type    = string
  default = "us-east-1"
}

variable "my_instance_type" {
  type = map(any)
  default = {
    dev     = "t2.micro"
    staging = "t2.medium"
    prod    = "t3.micro"
  }
}

variable "my_instance_name" {
  type    = string
  default = "Demo-ec2"
}

data.tf

#provider "aws" {}

# using default region.

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

Suppose u want to create 5 resources, in dev, staging, uat etc, if u want to achieve this 
u must create variables.
how can i read this var and return a no. bcos count is a no.
we use a fn called length - it will read d list and return d no. so d default can have many elements
in d list.
i want to find d length of this var called demo.count
for d Name i will call d var ie var.demo_count[count.index]. this var will read d value 
in my list and assign it an index eg dev=index0
So make this changes only in resource.tf above (see under) and run d codes above

resource.tf

resource "aws_instance" "test_ec2" {
  count         = length(var.demo_count)
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.my_instance_type["dev"]

  tags = {
    Name = var.demo_count[count.index]
  }
}

variable "demo_count" {
  type    = list(string)
  default = ["dev", "stage", "uat", "prod"]
}

terraform plan u see the instance on index3 is called prod, that on index 2 is called uat
that on index1 is called stage, and that on index0 is called dev.
so i have used d lenth fn to find d lenth of my var.
 What id ur boss says add hr and finance to d list
i will just add them to my varibles demo_count (under), i don;t need to change my code bcos
d length fn will automatically read this addition.

variable "demo_count" {
  type    = list(string)
  default = ["dev", "stage", "uat", "prod", "hr", finance"]
}
so above 5 instances will be created.

Suppose we have ust our 1st 4 instance.
assume u have created d 4 resources, and d production guys have deployed resources to prod,
d uat people have deployed to uat, staging has deployed resources, and dev has also deployed
resources.

Now suppose d boss says he does't need stage. what do u do
simply take out stage from ur code. default = ["dev", "uat", "prod"]
terraform plan- notices that uat is moved to stage position, prod is moved to index2.in plan u see 
plan = 2 add 1 destroy - we were expecting only to see 1 destroy.

actually this is not what u want, bcos people of prod deployed in prod and those in uat deployed 
to uat and not stage.
so u don't want it like tthis. what do u do?
THIS IS A LIMITATION OF COUNT META AGUMENT, BCOS IT RETURNS A LIST U CANNOT TAKE SOMETHING IN D MIDDLE OR 
BEGINNING OF A LIST.

So terra came out with a better mega argument called for_each

for_each
for each does not wk on list, so u cannot pass a list like above.
if u have a list u have to convert it to a set.
modify only resource.tf as below

#EC2Binstance configurations
resource "aws_instance" "test_ec2" {
  for_each = toset(var.demo_count)
  #count         = length(var.demo_count)
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.my_instance_type["dev"]

  tags = {
    Name = each.value
  }
}

variable "demo_count" {
  type    = list(string)
  default = ["dev", "uat", "prod"]
}

in terraform plan you see it is putting d name of d resource and not index no as for count.
it is only destroying what u deleted leaving d othrs unchanged.

so for each is more reliable /flexible when u are maging ur e't.
in wk e't u will see many for each.
so this is a meta argumetn it merely alters d behavior of how d resources will be 
created, d id etc remain d same.
so if u add stage in d middle of d var. it is going to add it without changing d others.

PROVIDER
our providr can also be a meta argumetn. bcos we can alter how we want tis resources to be 
created.
we cn pass a providr block, and we can say our region is us-east-1
then u can add another one with an alias and region as below. my default region is us-east-1

if i want to provision my rseource in another region, i can do as under in d resource conf.
d resource will be created in alias region

resource "aws_instance" "test_east2" {
  provider = aws.east
  for_each = toset(var.demo_count)
  #count         = length(var.demo_count)
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.my_instance_type["dev"]

  tags = {
    Name = each.value
  }
}

resource "aws_instance" "test_east1" {
  for_each = toset(var.demo_count)
  #count         = length(var.demo_count)
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.my_instance_type["dev"]

  tags = {
    Name = each.value
  }
}


variable "demo_count" {
  type    = list(string)
  default = ["dev", "uat", "prod"]
}

provider "aws" {
  region = "us-east-1"
}
#default region = "us-east-1"
provider "aws" {
  alias  = "east"
  region = "us-east-2"
}

it created 6 rsources why?  error
prof created another data.tf in count.dir. and modify d resource.tf as under.
he conf it as follows ie named it unbuntu_ami_1) see under 

data1.tf
data "aws_ami" "ubuntu_ami_1" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource.tf
#EC2Binstance configurations
resource "aws_instance" "test_east2" {
  provider = aws.east
  for_each = toset(var.demo_count)
  #count         = length(var.demo_count)
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.my_instance_type["dev"]

  tags = {
    Name = each.value
  }
}

resource "aws_instance" "test_east1" {
  for_each = toset(var.demo_count)
  #count         = length(var.demo_count)
  ami           = data.aws_ami.ubuntu_ami_1.id
  instance_type = var.my_instance_type["dev"]

  tags = {
    Name = each.value
  }
}


variable "demo_count" {
  type    = list(string)
  default = ["dev", "uat", "prod"]
}

provider "aws" {
  region = "us-east-1"
}
#default region = "us-east-1"
provider "aws" {
  alias  = "east"
  region = "us-east-2"
}

PROF PROMISED TO TROUBLE SHOOT BCOS REQD RESULT NOT GOT.

 
- There are 5 Meta-Arguments in Terraform which are as follows:
```
depends_on
count
for_each
provider
lifecycle

```

## a) depends_on
- Terraform has a feature of identifying resource dependency. This means that Terraform internally knows the sequence in which the dependent resources needs to be created whereas the independent resources are created in parallel.

- But in some scenarios, some dependencies are there that cannot be automatically inferred by Terraform. In these scenarios, a resource relies on some other resource’s behaviour but it doesn’t access any of the resource’s data in arguments.
- For those dependencies, we’ll use depends_on meta-argument to explicitly define the dependency.

- **depends_on** meta-argument must be a list of references to other resources in the same calling resource.

This argument is specified in resources as well as in modules (Terraform version 0.13+)

```
resource "aws_iam_role" "role" {
  name = "demo-role"
  assume_role_policy = "..."
}

# Terraform can infer automatically that the role must be created first.
resource "aws_iam_instance_profile" "instance-profile" {
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "policy" {
  name   = "demo-policy"
  role   = aws_iam_role.role.name
  policy = jsonencode({
  "Statement" = [{
  "Action" = "s3:*",
  "Effect" = "Allow",
  }],
 })
}


# Terraform can infer from this that the instance profile must
# be created before the EC2 instance.

resource "aws_instance" "ec2" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.instance-profile

  depends_on = [
  aws_iam_role_policy.policy
  ]
 }
 
# However, if software running in this EC2 instance needs access
# to the S3 API in order to boot properly, there is also a "hidden"
# dependency on the aws_iam_role_policy that Terraform cannot
# automatically infer, so it must be declared explicitly:
```        
## b) count

- In Terraform, a resource block actually configures only one infrastructure object by default. If we want multiple resources with same configurations, we can define the count meta-argument. 
- This will reduce the overhead of duplicating the resource block that number of times.

- count require a whole number and will then create that resource that number of times. To identify each of them, we use the count.index which is the index number that corresponds to each resource. The index ranges from 0 to count-1.

- This argument is specified in resources as well as in modules (Terraform version 0.13+). Also, count meta-argument cannot be used with for_each.

```
# create four similar EC2 instances

resource "aws_instance" "server" {
  count = 4
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"

 tags = {
 # Usage of count.index in providing a distinct name for every Instance
 Name = "Server-${count.index}"
  }
 }

output "instance_id" {
# Select all instance id using * in place of index value
value = aws_instance.server[*].id
}
```

## c) for_each
- As specified in the count meta-argument, that the default behaviour of a resource is to create a single infrastructure object which can be overridden by using count, but there is one more flexible way of doing the same which is by using for_each meta argument.

- The for_each meta argument accepts a map or set of strings. Terraform will create one instance of that resource for each member of that map or set. To identify each member of the for_each block, we have 2 objects:

   each.key: The map key or set member corresponding to each member.
   each.value: The map value corresponding to each member.
This argument is specified in resources (Terraform version 0.12.6) as well as in modules (Terraform version 0.13+)

```
## Example for map
resource "azurerm_resource_group" "rg" {
  for_each = {
  group_A = "eastus"
  group_B = "westus2"
 }
  name     = each.key
  location = each.value
}

## Example for set
resource "aws_iam_user" "accounts" {
for_each = toset( ["Developer", "Tester", "Administrator", "Cloud-Architect"] )
name     = each.key
}
```

## d) provider
- provider meta-argument specifies which provider to be used for a resource. This is useful when you are using multiple providers which is usually used when you are creating multi-region resources. For differentiating those providers, you use an alias field.
- The resource then reference the same alias field of the provider as **provider.alias** to tell which one to use.
```
## Default Provider
provider "google" {
  region = "us-central1"
}

## Another Provider
provider "google" {
  alias  = "europe"
  region = "europe-west1"
}

## Referencing the other provider
resource "google_compute_instance" "example" {
  provider = google.europe
}
```

## e) lifecycle

- The lifecycle meta-argument defines the lifecycle for the resource. As per the resource behaviour, Terraform can do the following:

    create a resource
    destroy a resource
    updated resource in place
    update resource by deleting existing and create new

- lifecycle is a nested block under resource that is used to customise that behaviour. Here are the following customisation that are available under lifecycle block

**create_before_destroy: (Type: Bool)**
For resource, where Terraform cannot do an in place updation due to API limitation, its default behaviour is to destroy the resource first and then re-create it. This can be changed by using this argument. It will first create the updated resource and then delete the old one.

**prevent_destroy: (Type: Bool)**
This will prevent the resource from destroying. It is a useful measure where we want to prevent a resource against accidental replacement such as database instances.

**ignore_changes: (Type: List(Attribute Names))**
By default, If Terraform detects any difference in the current state, it plans to update the remote object to match configuration. The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. It expects a list or map of values, whose updation will not recreate the resource. If we want all attributes to be passed here, we can simply use all.

- Ignore tag changes and won't recreate this resource if tags are updated
```
resource "aws_instance" "example" {
  lifecycle {
    ignore_changes = [
     tags,
   ]
   }
}
```
