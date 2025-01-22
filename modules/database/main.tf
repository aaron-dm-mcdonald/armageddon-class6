provider "aws" {
  region = var.region
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = "${var.name}-aurora-cluster"
  database_name      = var.name

  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.2"

  # manage_master_user_password   = true
  master_username = var.db_user # add the secret manager you idiot
  master_password = var.db_password

  vpc_security_group_ids = [aws_security_group.this.id]
  db_subnet_group_name   = var.db_subnet_group

  storage_encrypted   = false
  skip_final_snapshot = true
}

resource "aws_rds_cluster_instance" "this" {
  count = var.instance_count

  identifier         = "${var.name}-aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id

  instance_class = var.instance_class
  engine         = aws_rds_cluster.this.engine
  engine_version = aws_rds_cluster.this.engine_version

  publicly_accessible  = false
  db_subnet_group_name = var.db_subnet_group

  force_destroy = true
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc_id
  name        = "${var.name}-db-sg"
  description = "${var.name}-db-sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-db-sg"
  }
}

