resource "aws_vpc" "this" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
}

resource "aws_subnet" "private_sn_1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}
# create a route table for private_sn_1
resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.this.id
}
# create a route to reach 10.0.0.0/24 from private_rt_1
resource "aws_route" "private_route_1" {
  route_table_id = aws_route_table.private_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id 
}

#  create a route table associate between private_rt_1 private_route_1 and private_sn_1
resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_sn_1.id
  route_table_id = aws_route_table.private_rt_1.id
}
resource "aws_subnet" "private_sn_2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

// start of public subnet
resource "aws_subnet" "public_sn" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.0.0.0/24" 
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id 

}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public_sn.id
  route_table_id = aws_route_table.public_rt.id
  
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "private_sn_1_rt" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "private_sn_1_public_sn" {
    route_table_id = aws_route_table.private_sn_1_rt.id
    destination_cidr_block = "10.0.0.0/24"
    # gateway_id = aws_internet_gateway.this.id  
    transit_gateway_id = aws_ec2_transit_gateway.this.id

}

resource "aws_route_table_association" "private_sn_1_public_sn" {
  subnet_id = aws_subnet.private_sn_1
  route_table_id = aws_route_table.private_sn_1_rt.id
  
}


resource "aws_ec2_transit_gateway" "this" {
    description = "transit gateway"
    # auto_accept_shared_attachments = enable 
    # default_route_table_association = enable
    # default_route_table_propagation = enable
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
}

/*
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.public_sn_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

# resource "aws_ec2_transit_gateway_vpc_attachment" "public_sn_attachment" {
#   subnet_ids         = [aws_subnet.public_sn.id]
#   transit_gateway_id = aws_ec2_transit_gateway.this.id
#   vpc_id             = aws_vpc.this.id
# }
# resource "aws_ec2_transit_gateway_vpc_attachment" "private_sn_1_attachment" {
#   subnet_ids         = [aws_subnet.private_sn_1.id]
#   transit_gateway_id = aws_ec2_transit_gateway.this.id
#   vpc_id             = aws_vpc.this.id
# }
# resource "aws_ec2_transit_gateway_vpc_attachment" "private_sn_2_attachment" {
#   subnet_ids         = [aws_subnet.private_sn_2.id]
#   transit_gateway_id = aws_ec2_transit_gateway.this.id
#   vpc_id             = aws_vpc.this.id
# }

resource "aws_ec2_transit_gateway_route" "public_sn_to_private_sn_1_route" {
  destination_cidr_block        = aws_subnet.private_sn_1.cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.private_sn_1_attachment.id
}
resource "aws_ec2_transit_gateway_route" "public_sn_to_private_sn_2_route" {
  destination_cidr_block        = aws_subnet.private_sn_1.cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.private_sn_1_attachment.id
}
*/