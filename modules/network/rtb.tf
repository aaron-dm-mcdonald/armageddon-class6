############public route table##########

resource "aws_route_table" "public" {


  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = var.tgw_id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}


resource "aws_route_table_association" "public" {
  count = var.num_public_subnets

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


############private route table##########

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = length(aws_nat_gateway.main) > 0 ? [aws_nat_gateway.main[0]] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = route.value.id
    }
  }

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = var.tgw_id
  }

  tags = {
    Name = "${var.name}-private-rt"
  }
}






resource "aws_route_table_association" "private" {
  count = var.num_private_subnets

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

##########################################

resource "aws_route_table_association" "database" {
  count = var.num_database_subnets

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.private.id
}
