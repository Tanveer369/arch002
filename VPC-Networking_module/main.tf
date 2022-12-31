######################################
#####VPC Block
######################################

resource "aws_vpc" "architecture2-vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = var.vpc_tag_name
  }
}

######################################
##### internet Gateway
######################################

resource "aws_internet_gateway" "public-igw" {
  vpc_id = aws_vpc.architecture2-vpc.id

  tags = {
    Name = var.igw_tag
  }
}

#####################################
##### Public Subnets
#####################################

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.architecture2-vpc.id
  cidr_block              = var.pub_sub_1_cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available-in-us-east-2.names[0]

  tags = {
    Name = var.pub_sub_1_tag
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.architecture2-vpc.id
  cidr_block              = var.pub_sub_2_cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available-in-us-east-2.names[1]

  tags = {
    Name = var.pub_sub_2_tag
  }
}


#####################################
##### Private Subnets
#####################################

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.architecture2-vpc.id
  cidr_block        = var.pvt_sub_1_cidr
  availability_zone = data.aws_availability_zones.available-in-us-east-2.names[0]

  tags = {
    Name = var.pvt_sub_1_tag
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.architecture2-vpc.id
  cidr_block        = var.pvt_sub_2_cidr
  availability_zone = data.aws_availability_zones.available-in-us-east-2.names[1]

  tags = {
    Name = var.pvt_sub_2_tag
  }
}




####################################
##### Nat gateway
####################################

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = var.nat_gateway_tag
  }

  depends_on = [aws_internet_gateway.public-igw]
}

#################################################
######### Private Route Table
#################################################

resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.architecture2-vpc.id

  route = []
  depends_on                = [aws_nat_gateway.nat_gateway]
  tags = {
    Name = var.private_route_tag
  }
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.privateroute.id
  destination_cidr_block    = var.destination_cidr_block_nat
  gateway_id = aws_nat_gateway.nat_gateway.id
  depends_on                = [aws_route_table.privateroute]
}

###############################################
##### Public Route Table
###############################################

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.architecture2-vpc.id

  route = []

  tags = {
    Name = var.public_route_tag
  }
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.publicroute.id
  destination_cidr_block    = var.destination_cidr_block_igw
  gateway_id = aws_internet_gateway.public-igw.id
  depends_on                = [aws_route_table.publicroute]
}

###############################################
### Route Table Association
###############################################

resource "aws_route_table_association" "public_route_association1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.publicroute.id
}

resource "aws_route_table_association" "public_route_association2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.publicroute.id
}

resource "aws_route_table_association" "private_route_association3" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.privateroute.id
}

resource "aws_route_table_association" "private_route_association4" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.privateroute.id
}


