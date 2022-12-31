variable "pub_sub_1_tag" {
  type = string
  default = "public-subnet_1"
}

variable "map_public_ip_on_launch" {
  type = bool
  default = true
}

variable "pub_sub_1_cidr" {
  type = string
  default = "172.16.1.0/24"
}

variable "igw_tag" {
  type = string
  default = "arc2-igw"
}

variable "vpc_tag_name" {
  type = string
  default = "architecture2-vpc"
}


variable "vpc_cidr_block" {
  type = string
  default = "172.16.0.0/16"
}

variable "instance_tenancy" {
  type = string
  default = "default"
}

variable "pub_sub_2_cidr" {
  type = string
  default = "172.16.2.0/24"
}

variable "pub_sub_2_tag" {
  type = string
  default = "public-subnet_2"
}

variable "pvt_sub_1_cidr" {
  type = string
  default = "172.16.3.0/24"
}


variable "pvt_sub_1_tag" {
  type = string
  default = "nginx-subnet-1"
}


variable "pvt_sub_2_cidr" {
  type = string
  default = "172.16.4.0/24"
}


variable "pvt_sub_2_tag" {
  type = string
  default = "nginx-subnet-2"
}


variable "private_route_tag" {
  type = string
  default = "private-rt"
}

variable "public_route_tag" {
  type = string
  default = "public-rt"
}


variable "access_key" {
  type = string
  default = "AKIAYYEJ3NBVVFSW7VMH"
}

variable "secret_key" {
  type = string
  default = "U4B/1R2lz9Ef7E6RMW0ID6m//e7yAoDrUpBeXslz"
}

variable "nat_gateway_tag" {
  type = string
  default = "nat-gateway"
}

variable "destination_cidr_block_nat" {
  type = string
  default = "0.0.0.0/0"
}

variable "destination_cidr_block_igw" {
  type = string
  default = "0.0.0.0/0"
}



