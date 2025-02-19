## How to pass aws credentials to terraform provider

- The AWS provider offers a flexible means of providing credentials for authentication.
- The following methods are supported, in this order, and explained below:

-1  Static credentials**
```
     provider "aws" {
       region     = "us-west-2"
       access_key = "my-access-key"
       secret_key = "my-secret-key"
    }

DO NOT USE static credentials (Hard coded)in Terraform files.
🔹 Instead, use IAM roles, environment variables, or AWS profiles for secure authentication.

```
-2  **Environment variables**
```
     $ export AWS_ACCESS_KEY_ID="accesskey"
     $ export AWS_SECRET_ACCESS_KEY="secretkey"
     $ export AWS_DEFAULT_REGION="us-west-2"
```

- **Shared credentials/configuration file**
3 ```
    provider "aws" {
      region                  = "us-west-2"
      shared_credentials_file = "/Users/Ken/.aws/credentials"
      profile                 = "terraform_user"
  }
```


ex for No. 3) Use AWS Named Profiles (Best for Local Development)
Set up credentials in ~/.aws/credentials and specify a profile.

Step 1: Configure ~/.aws/credentials


[my-profile]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY

Step 2: Reference the profile in Terraform

provider "aws" {
  region  = "us-east-1"
  profile = "my-profile"
}
This avoids exposing credentials in code.
