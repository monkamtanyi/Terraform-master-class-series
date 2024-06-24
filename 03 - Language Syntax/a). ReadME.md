# Terraform Configuration Language Syntax

## a) **Terraform top level Blocks**
https://www.terraform.io/docs/configuration/syntax.html
- A block is a container for other content.
- An example of a block template is as below.
## Template
#d content of d curly braces represent d content of a block.
blk type =prvidr, resources, etc

blk label= resource type (ie if blk type =resource as an ex)
blk label =d name, local to terra, this will differentiate diff resources- u can 
create many instanes with diff names.
Blocks are containers for code, delimited by d curly braces.
we pass aguements in d curly braces.
In terraform everything we create will be a resource, all resource blks req. 2 labels
other blks req 1 label.


#Template
     <BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>"   {
       # Block body
      <IDENTIFIER> = <EXPRESSION> # Argument
     }
ha


## Terraform has 10 high level blocks
      - Terraform Settings Block
      - Provider Block
      - Resource Block
      - Input Variables Block
      - Output Values Block
      - Local Values Block
      - Data Sources Block
      - Modules Block
      - Moved Blocks
      - Import block

## AWS Example of a resource block.
```
resource "aws_instance" "ec2demo" {
  # BLOCK BODY
  ami           = "ami-04d29b6f966df1537" # Argument
  instance_type = var.instance_type # Argument with value as expression (Variable value replaced from variables.tf)

      network_interface {
       # ...
    }
  }
```
- A block has a type (resource in this example). Each block type defines how many labels must follow the type keyword. The resource block type expects two labels, which are aws_instance and ec2demo in the example above. A particular block type may have any number of required labels, or it may require none as with the nested network_interface block type.

- After the block type keyword and any labels, the block body is delimited by the { and } characters. Within the block body, further arguments and blocks may be nested, creating a hierarchy of blocks and their associated arguments.

## b) **Arguments, Expressions, Attributes & Meta-Arguments**

## Arguments
- They assign a value to a name. They appear within blocks. Arguments can be required (eg i can't create an instance without d ami, or instance type) or optional(eg if i want to pass a key, bcos i can create an instance without d key).
- ami is an aguement and is assigned an expression- d value will be got from somwhere else. instance_type is an aguement, and is assigned an expression, d value will be got from somewhere else.

## Expressions
- They represent a value, either literally or by referencing and combining other values. They appear as values for arguments, or within other expressions.
eg ami-04d29b6f966df1537 above is an expression.


## Attributes
- They represent a named piece of data that belongs to some kind of object. The value of an attribute can be referenced in expressions using a dot-separated notation, like aws_instance.example.id.
-  when i create an instance, what i am passing in is called aguement, eg i am passing in an ami, ami is an aguement. after d instance is created
 we can get its id, private ip etc. an id or private ip is an attribute.
- aguements are what we pass onto a resource, while attributes is what we get out of d resource after it has been created.
  
- The format looks like `resource_type.resource_name.attribute_name`
- 
resource_type=aws_instance, resource_name=ec2demo, attribute_name=public_ip
got attribute_name from d attribute reference in aws_instance resource found in terra registry.
it becomes

aws_instance.ec2demo.public_ip
to get instance id as output- i check id in d reg as above. 
aws_instance.ec2demo.id

so if u need d pu ip of an instance, create an output block

output "instance_private_ip" {               
  value = aws_instance.ec2demo.private_ip
}
give it a label eg instance_private_ip




## Identifiers
- Argument names, block type names, and the names of most Terraform-specific constructs like resources, input variables, etc. are all identifiers.

- Identifiers can contain letters, digits, underscores (_), and hyphens (-). The first character of an identifier must not be a digit, to avoid ambiguity with literal numbers.

## Comments
- The Terraform language supports three different syntax for comments:
```
The # begins a single-line comment, ending at the end of the line.
// also begins a single-line comment, as an alternative to #.
/* and */ are start and end delimiters for a comment that might span over multiple lines.
The # single-line comment style is the default comment style and should be used in most cases. Automatic configuration formatting tools may automatically transform // comments into # comments, since the double-slash style is not idiomatic.
```

