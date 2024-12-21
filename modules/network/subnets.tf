

resource "aws_subnet" "public" {
  count                    = var.num_public_subnets
  
  vpc_id                   = aws_vpc.main.id
  cidr_block               = var.public_subnet_cidr[count.index]
  availability_zone        = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.name}-public-${count.index + 1}"
  }
}



resource "aws_subnet" "private" {
  count = var.num_private_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}


resource "aws_subnet" "database" {
  count                   = var.num_database_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.database_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index + 1]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-database-${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "database" {
  count = var.num_database_subnets > 0 ? 1 : 0

  name       = "${var.name}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${var.name}-db-subnet-group"
  }
}


