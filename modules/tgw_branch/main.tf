resource "aws_ec2_transit_gateway" "main" {
  provider                       = aws.default
  description                    = "Transit Gateway"
  auto_accept_shared_attachments = "enable"

  tags = {
    Name = "${var.name}-transit-gateway"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  provider           = aws.default
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.vpc_id
  subnet_ids         = var.private_subnet_ids

  tags = {
    Name = "${var.name}-transit-gateway-attachment"
  }
}

#####################route table################

data "aws_ec2_transit_gateway_route_table" "main" {
  provider = aws.default

  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.main.id]
  }

  tags = {
    Name = "tgw-rtb-${var.region}"
  }
}

resource "aws_ec2_transit_gateway_route" "main" {
  provider                       = aws.default
  destination_cidr_block         = "10.0.0.0/8"
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.main.id
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_peering_attachment.main.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.tokyo, aws_ec2_transit_gateway_peering_attachment_accepter.main,
    data.aws_ec2_transit_gateway_peering_attachment.main
  ]
}


#####################peering attachment################

resource "aws_ec2_transit_gateway_peering_attachment" "tokyo" {
  provider                = aws.tokyo
  peer_region             = var.region
  peer_transit_gateway_id = aws_ec2_transit_gateway.main.id
  transit_gateway_id      = var.peer_tgw_id

  tags = {
    Name = "${var.name}-to-tokyo"
  }
}

data "aws_ec2_transit_gateway_peering_attachment" "main" {
  provider   = aws.default
  depends_on = [aws_ec2_transit_gateway_peering_attachment.tokyo]
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.main.id]
  }

  filter {
    name   = "state"
    values = ["pendingAcceptance", "available"]
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "main" {
  provider                      = aws.default
  transit_gateway_attachment_id = data.aws_ec2_transit_gateway_peering_attachment.main.id
}

##################tokyo route################

data "aws_ec2_transit_gateway_route_table" "tokyo" {
  provider = aws.tokyo

  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = [var.peer_tgw_id]
  }

  tags = {
    Name = "tgw-rtb-tokyo"
  }

  # depends_on = [var.peer_tgw_id]
}

resource "aws_ec2_transit_gateway_route" "to_other_region" {
  provider = aws.tokyo
  count    = var.enable_return_route ? 1 : 0

  destination_cidr_block         = var.vpc_cidr
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tokyo.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tokyo.id


  depends_on = [aws_ec2_transit_gateway_peering_attachment.tokyo, aws_ec2_transit_gateway_peering_attachment_accepter.main,
    data.aws_ec2_transit_gateway_peering_attachment.main
  ]


}