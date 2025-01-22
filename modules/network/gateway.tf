resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-igw"
  }
}


resource "aws_eip" "nat" {

  tags = {
    Name = "${var.name}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  count = var.num_public_subnets > 0 ? 1 : 0

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.name}-nat"
  }
}

