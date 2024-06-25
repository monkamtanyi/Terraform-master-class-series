## **Variables**

- A variable is a value that can change, depending on conditions or on information passed to the program.
- Variables are used to store information to be referenced and manipulated in a computer program.
- They also provide a way of labeling data with a descriptive name, so our programs can be understood more clearly by the reader and ourselves.
- It is helpful to think of variables as containers that hold information. Their sole purpose is to label and store data in memory. This data can then be used throughout your program.

The following example shows the variable types that are supported by terraform.

**String**     #
 - Strings are usually represented by a double-quoted sequence of Unicode characters, "like this"
```
variable "vpcname" {   #expect 1 label unique to terra
  type    = string
  default = "myvpc"
}

```
**Number**

- Numbers are represented by unquoted sequences of digits with or without a decimal point, like 15 or 6.283185.
```t
variable "sshport" {
  type    = number
  default = 22
}
```

**Boolean**
- Bools are represented by the unquoted symbols true and false.
```t
      variable "boolean" {
          type = bool
    }      default = true or can be false
```
use below
variable "boolean" {
 type = bool
 default = false
}


**List**
- Lists is represented by a pair of square brackets containing a comma-separated sequence of values, like ["a", 15, true].
```t
variable "mylist" {              # eg i can have a list of instances.
  type    = list(string)
  default = ["Value1", "Value2"]    d first value in a list is indexed as 0, d 2nd as 1 etc
}
```
- How do you reference List values ?
  
 - instance_type = var.mylist[1]   [1] = what index value i want from d list,
   here shows 2nd value- value2

**Map**
- Maps/objects are represented by a pair of curly braces containing a series of KEY = VALUE pairs:
``` a map is a key value pair.
variable "mymap" {
  type = map
  default = {        #eg passing tags. u can have many tags w u pass as key value pairs
    Key1 = "Value1"  #d blks that we pass is mostly key value pairs bcos ami=..., instance type=... etc
    Key2 = "Value2"
  }
}
```
- How do you reference Map values ?
 
    - instance_type = var.mymap["key1"]  to get value1, we pass key1 as shown here

**Input**
 ```
variable "inputname" {   
  type        = string
  description = "Set the name of the VPC"
}
```
- note that if no default value is provided, then the variable will be an input variable
   and will prompt you to enter a value at runtime.
- how do y make a variable reqd- by taking out d default value and allowin d user user to
   input that value on a command line.

 ```
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.inputname
  }
}
```
**Output**
```t
output "vpcid" {
  value = aws_vpc.myvpc.id
}
```
**Tuple**
- Lists/tuples are represented by a pair of square brackets containing a comma-separated sequence of values, like ["a", 15, true].
```t
variable "mytuple" {
  type    = tuple([string, number, string])
  default = ["cat", 1, "dog"]
}
```
**Objects**
```t
variable "myobject" {
  type = object({ name = string, port = list(number) })
  default = {
    name = "Landmark"
    port = [22, 25, 80]
  }
}
```
**Variables with Lists and Maps**

a) AWS EC2 Instance Type - List
```t
 variable "instance_type_list" {
  description = "EC2 Instance Type"
  type = list(string)
  default = ["t3.micro", "t3.small"]
}

#instance_type = var.instance_type_list[0]
```
 
b) AWS EC2 Instance Type - Map
```t
 variable "instance_type_map" {
  description = "EC2 Instance Type"
  type = map(string)
  default = {
    "dev" = "t3.micro"
    "qa"  = "t3.small"
    "prod" = "t3.large"
  }
}

#instance_type = var.instance_type_map["qa"]
```
