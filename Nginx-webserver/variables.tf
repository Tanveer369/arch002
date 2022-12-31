variable "region_name" {
  type    = string
  default = "us-east-2"
}

variable "description_nginx_sg" {
  type    = string
  default = "nginx webserever network traffic"
}

variable "nginx_sg_name" {
  type    = string
  default = "nginxsg"
}

variable "nginx_sg_tag" {
  type    = string
  default = "nginx-webserver-all-traffic"
}

variable "description_alb_sg" {
  type    = string
  default = "alb network traffic"
}

variable "alb_sg_name" {
  type    = string
  default = "albsg"
}


variable "alb_sg_tag" {
  type    = string
  default = "alb-all-traffic"
}
variable "key_name" {
  type    = string
  default = "archi2-key"
}

variable "alb_name" {
  type    = string
  default = "archi2-alb"
}

variable "internal_or_internet_facing_alb" {
  type    = bool
  default = false
}

variable "type_of_load_balancer" {
  type    = string
  default = "application"
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "alb_environment_tag" {
  type    = string
  default = "production"
}

variable "target_group_name" {
  type    = string
  default = "architg"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "resource_type" {
  type    = string
  default = "instance"
}

variable "launch_configuration_tag" {
  type    = string
  default = "asg-launch-config"
}

variable "alb_desired_capacity" {
  type    = number
  default = 2
}

variable "alb_max_size" {
  type    = number
  default = 2
}

variable "alb_min_size" {
  type    = number
  default = 2
}

variable "health_check_grace_period" {
  type    = number
  default = 300
}

variable "health_check_type" {
  type    = string
  default = "ELB"
}

# variable "key_name_lb" {
#   type    = string
#   default = "archi2-key.pub"
# }