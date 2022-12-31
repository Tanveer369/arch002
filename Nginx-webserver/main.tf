##########################
### nginx webserver server security group 
##########################

resource "aws_security_group" "nginx-sg" {
  vpc_id      = data.aws_vpc.vpc_selected.id
  description = var.description_nginx_sg
  name        = var.nginx_sg_name

  dynamic "ingress" {
    for_each = [22, 80, 443]
    iterator = port
    content {
      description = "ssh http https from anywhere"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = var.nginx_sg_tag
  }
}

#################################
### alb security group
###############################

resource "aws_security_group" "alb_sg" {
  vpc_id      = data.aws_vpc.vpc_selected.id
  description = var.description_alb_sg
  name        = var.alb_sg_name

  dynamic "ingress" {
    for_each = [80, 443]
    iterator = port
    content {
      description = "http https from anywhere"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = var.alb_sg_tag
  }
}

#################################
#### Key pair
#################################

# resource "aws_key_pair" "archi2-key" {
#   key_name   = var.key_name
#   public_key = file("${path.module}/archi2_key.pub")
# }

###################################
### ALB
###################################

resource "aws_lb" "archi2_alb" {
  name               = var.alb_name
  internal           = var.internal_or_internet_facing_alb
  load_balancer_type = var.type_of_load_balancer
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [data.aws_subnet.pub-subnet-1.id, data.aws_subnet.pub-subnet-2.id]

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Environment = var.alb_environment_tag
  }
}

#######################################
###### alb target group
######################################

resource "aws_lb_target_group" "arci2_alb_target_group" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_selected.id

  tags = {
    "Name" = "tg"
  }
}

#####################################
### alb listners 
#####################################

resource "aws_lb_listener" "alb_listners" {
  load_balancer_arn = aws_lb.archi2_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.arci2_alb_target_group.arn
  }
}

#########################################
##### asg launch configuration
#########################################

resource "aws_launch_configuration" "launch_config" {
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  user_data                   = filebase64("${path.module}/ec2.userdata")
  associate_public_ip_address = var.associate_public_ip_address
  security_groups             = [aws_security_group.nginx-sg.id]
  key_name                    = "archi2_key"

}

##############################
##### Autoscaling group
##############################


resource "aws_autoscaling_group" "archi_asg1" {
  vpc_zone_identifier       = [data.aws_subnet.pvt-sub2.id, data.aws_subnet.pvt-sub2.id]
  desired_capacity          = var.alb_desired_capacity
  max_size                  = var.alb_max_size
  min_size                  = var.alb_min_size
  launch_configuration      = aws_launch_configuration.launch_config.name
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type

  depends_on = [
    aws_lb.archi2_alb
  ]

  tag {
    key   = "Name"
    value = "archiasg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.archi_asg1.id
  lb_target_group_arn    = aws_lb_target_group.arci2_alb_target_group.arn
}
