# Terraform Command Basics

## Terraform configuration files
   - Terraform uses declarative syntax to describe your Infrastructure as Code (IaC) infrastructure
   and then persist it in configuration files that can be shared, reviewed, edited, versioned,
   preserved, and reused.
   - Terraform configuration files can use either of two formats: Terraform domain-specific
   language (HashiCorp Configuration Language format [HCL]), which is the recommended
   approach, or JSON format if the files need to be machine-readable.
   - Configuration files that use the HCL format end with the .tf file extension;
   - Those using JSON format end with the .tf.json file extension.
   - The Terraform format is human-readable, while the JSON format is machine readable


## Terraform workflow   :how u execute commands in terraf
**terraform init**: it is going to read d configuration files within that 
dir. wherever ur conf dir are, is called d wking dir.
when it reads ur conf file, it is looking for who ur provider is.
after identifying ur provider, it goes to d registry and download your
provider plugin(its like ur api of aws, it download and brings it to ur e't, this is d api that will be interacting with aws api). if u are writing ur code as a module it will go to d reg and download that module. b4 u can start wking with it.
if ur provider is google it will go to d reg and download that provider b4 u start wking with it.


  - Used to initialize a working directory containing terraform config files. 
  - This is the first command that should be run after writing a new terraform configuration file. 
  - It downloads providers and modules

**terraform validate**:
  - Validates the configuration files in the respective directory to ensure that they are syntactically valid and internally consistent. bcos when u are writing a teraform manifest file -terra conf files, it has to adhere to hashicorp configuration language w is human readable.
 so terra has to validate if what u have written is valid.   

**terraform plan**:
  - Creates an execution plan 
  - Terraform performs a refresh and determines what actions are necessary to achieve the desired state specified in the configuration files

  - once u have ur apis or providers downloaded, when u run plan, u arre telling this
   api to go to aws and find out if d conf files that u created is able to create that rsesource.
this is d pt where u need ur aws credentials bcos it has to interact with aws to enable it generate a plan for u.
if u want to create an ec2 instance 4 ex, it will read this in d conf file, and make a plan to ensure that u achieve that desired step.
so u have to review d plan and approve d plan, then run terraform apply

**terraform apply**:
  - Used to apply the changes required to reach the desired state of the configuration 
  - By default, apply scans the current dterra irectory for the configuration and applies the changes appropriately.
  - The statefile is created when apply is ran the first time.
  - When you run terraform apply, Terraform reads your configuration files, determines what changes need to be made to your infrastructure, applies those changes, and then updates the state file to reflect the new state of your infrastructure. This state file is crucial for Terraform to manage your infrastructure effectively, enabling features like dependency tracking, resource management, and state management.
  - However, the state file is not created for every configuration file individually. Instead, it represents the state of the entire infrastructure described by all your Terraform configuration files within a specific directory (usually referred to as a Terraform workspace or project).
  - The Terraform state file is created for each Terraform workspace or working directory. When you initialize a new Terraform project with terraform init and then apply changes with terraform apply, Terraform creates and manages a state file specific to that workspace.

Each workspace has its own state file because it tracks the state of the infrastructure described by the Terraform configuration files within that directory. This separation ensures that changes made in one workspace do not interfere with the state of another workspace, allowing for isolation and better management of different environments or configurations.

**terraform destroy**:
 - Use to destroy terraform managed infrastructure.
 - This will ask for confirmation before destroying.    

## Prerequisites
in whatever region u want to create ur resources(eg ec2 instance, just make sure u have a default vpc there.
ie if u are creaating say an ec2, if u don't pass any  vpc id, then d resource will be placed in default vpc.

- **Pre-Conditions-1:** Ensure you have **default-vpc** in that respective region
- **Pre-Conditions-2:** Ensure AMI you are provisioning exists in that region if not update AMI ID (AMI is region specific)
- **Pre-Conditions-3:** Verify your AWS Credentials in **$HOME/.aws/credentials**

```
# Terraform Settings Block
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"            # Optional but recommended in production
    }
  }
}

# Provider Block
provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

# Resource Block
resource "aws_instance" "ec2demo" {
  ami           = "ami-0e5b6b6a9f3db6db8"
  instance_type = "t2.micro"
}
```



## Verify the EC2 Instance in AWS Management Console
- Go to AWS Management Console -> Services -> EC2
- Verify newly created EC2 instance


## Destroy Infrastructure
    terraform destroy
