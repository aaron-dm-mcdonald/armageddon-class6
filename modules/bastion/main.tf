

data "aws_ami" "this" {
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


# Security Group for Bastion Host
resource "aws_security_group" "this" {
  name        = "${var.name}-bastion"
  description = "Allow SSH and ICMP access to the bastion host"
  vpc_id      = var.vpc_id

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP for production
  }

  # Allow ICMP traffic (e.g., ping)
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP or network
  }

  # Allow all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-bastion-sg"
  }
}




# EC2 Instance
resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.this.id # Amazon Linux 2 AMI (replace with the region-specific AMI ID)
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_ids
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

  tags = {
    Name = "${var.name}-bastion-host"
  }

  user_data = var.user_data
}