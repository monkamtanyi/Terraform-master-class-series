# **Introduction to Terraform**

## Key Concepts

## a) **Infrastructure as a Code**
  - Managing and provisioning of infrastructure through code instead of manually
  - Files that contain configurations are created and makes it easy to edit and distribute/share
  - Ensures that the same environment is provisioned everytime.
  - Helps avoid undocumented, ad-hoc configuration changes
  - Easy to version control
  - Can create infrastructure in modular components
  - Gives you a template to follow for provisioning

## b) **Benefits**
  - Cost reduction
  - Increase in speed of deployment
  - Reduce errors
  - Improve infrastructure consistency
  - Eliminate configuration drift : occurs when the actual state of an infrastructure or application
     environment diverges from its intended, defined, or expected state. Due to manual changes,
    inconsistent updates, or unmanaged configurations. This can lead to security vulnerabilities,
    system instability, and deployment failures

## **What is Terraform?**  vendor of terraform is hashicorp  (vendor of cloud infrastructure automation)    
  - IaaC tool from Hashicorp     https://www.hashicorp.com/  https://www.terraform.io/
  - Used for building, changing and managing infrastructure in a safe, repeatable way
  - Uses HCL - Hashicorp Configuration Language - human readable
  - Reads configuration files and provides an execution plan which can be reviewed before being applied.
  - It is platform agnostic - can manage a heterogeneous environment - multi cloud. u can use it
    on multiple clouds or e't or providers  - aws,dk, k8s, azure etc that's why terraf. thrives. 
  - State management - creates a state file when a project is first initialized. Uses this state file to  create plans and make changes based on the desired and current state of the infrastructure.
   when u have ur configuration file, terra will use to to create a state file w it uses to
   mge ur configuration.
  - Creates operator confidence

  ## **Terraform Configuration Files**
 ( terra vs ansible:terra is declarative ie it does not matter where d files are located/dir as long as u have given it a path, it willread thro all d files, and will come out with a plan. ansible wks from d top to bottom so it is proceedural-follws a certain order or proceedure)
- Terraform uses declarative syntax to describe your Infrastructure as Code (IaC) infrastructure
and then persist it in configuration files that can be shared, reviewed, edited, versioned,
preserved, and reused.
- Terraform configuration files can use either of two formats: Terraform domain-specific
language (HashiCorpConfiguration Language format [HCL]), which is the recommended
approach, or JSON format if the files need to be machine-readable.
- Configuration files that use the HCL format end with the .tf file extension;
- Those using JSON format end with the .tf.json file extension.
- The Terraform format is human-readable, while the JSON format is machine readable
