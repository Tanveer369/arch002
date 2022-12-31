#########################
#### ami datasource
#########################

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-2022*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

##################################
###### data fetch vpc details
##################################

data "aws_vpc" "vpc_selected" {
  filter {
    name   = "tag:Name"
    values = ["architecture2-vpc"]
  }
}

#################################
##### data fetch for subnet
#################################

data "aws_subnet" "pub-subnet-1" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet_1"]
  }
}

data "aws_subnet" "pub-subnet-2" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet_2"]
  }
}

data "aws_subnet" "pvt_sub1" {
  filter {
    name   = "tag:Name"
    values = ["nginx-subnet-1"]
  }
}

data "aws_subnet" "pvt-sub2" {
  filter {
    name   = "tag:Name"
    values = ["nginx-subnet-2"]
  }
}