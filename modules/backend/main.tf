provider "aws" {
  region = var.region
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "ena-support"
    values = ["true"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.name}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.name}-target-group"
  }
}

resource "aws_launch_template" "launch_template" {
  name_prefix            = "${var.name}-launch-template"
  image_id               = data.aws_ami.ami.id
  instance_type          = var.backend_instance_type
  vpc_security_group_ids = [aws_security_group.backend_sg.id, aws_security_group.syslog_data.id]
  # Dynamically generate user_data with environment variables
  user_data = var.user_data

  tags = {
    Name = "${var.name}-instance"
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = var.desired_capacity
  max_size         = var.scaling_range[1]
  min_size         = var.scaling_range[0]
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [var.private_subnet_ids[0], var.private_subnet_ids[1]]
  target_group_arns         = [aws_lb_target_group.target_group.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "backend_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.frontend_sg_id]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-backend-sg"
  }
}

resource "aws_security_group" "syslog_data" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  ingress {
    from_port   = 514
    to_port     = 514
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  tags = {
    Name = "${var.name}-syslog-sg"
  }
}



