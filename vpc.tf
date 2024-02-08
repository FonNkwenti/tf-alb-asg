resource "aws_vpc" "this" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
resource "aws_subnet" "private_sn_az1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
    tags = {
    Name = "Private Subnet AZ1"
  }
}
# create a route table for private_sn_az1
resource "aws_route_table" "private_rt_az1" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_az1.id
  }
  tags   = {
    Name = "Private Route Table AZ1"
  }
}

#  create a route table associate between private_rt_az1 private_route_1 and private_sn_az1
resource "aws_route_table_association" "private_rta1_az1" {
  subnet_id = aws_subnet.private_sn_az1.id
  route_table_id = aws_route_table.private_rt_az1.id
}
resource "aws_subnet" "private_sn_az2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
    tags = {
    Name = "Private Subnet AZ2"
  }
}

resource "aws_route_table" "private_rt_az2" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_az2.id
  }
  tags   = {
    Name = "Private Route Table AZ2"
  }
  
}

resource "aws_route_table_association" "private_rta1_az2" {
  subnet_id = aws_subnet.private_sn_az2.id
  route_table_id = aws_route_table.private_rt_az2.id
}

// start of public subnet
resource "aws_subnet" "public_sn_az1" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.0.0.0/26" 
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-sn-az1"
  }
}
resource "aws_subnet" "public_sn_az2" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.0.0.128/26" 
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-sn-az2"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }
        tags = {
    Name = "Public Route Table for AZ1 & AZ2"
  }
}

resource "aws_route_table_association" "public_rta_az1" {
  subnet_id = aws_subnet.public_sn_az1.id
  route_table_id = aws_route_table.public_rt.id
  
}
resource "aws_route_table_association" "public_rta_az2" {
  subnet_id = aws_subnet.public_sn_az2.id
  route_table_id = aws_route_table.public_rt.id
  
}
# resource "aws_route_table" "public_rt_az2" {
#   vpc_id = aws_vpc.this.id
#     route {
#     cidr_block = "10.0.0.0/16"
#     gateway_id = "local"
#   }

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.this.id
#     }
# }

# resource "aws_route_table_association" "public_rta2" {
#   subnet_id = aws_subnet.public_sn_az2.id
#   route_table_id = aws_route_table.public_rt_az2.id
  
# }




// transit gateway 

/*
resource "aws_ec2_transit_gateway" "this" {
    description = "transit gateway"
    # auto_accept_shared_attachments = enable 
    # default_route_table_association = enable
    # default_route_table_propagation = enable
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.public_sn_az1_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

# resource "aws_ec2_transit_gateway_vpc_attachment" "public_sn_az1_attachment" {
#   subnet_ids         = [aws_subnet.public_sn_az1.id]
#   transit_gateway_id = aws_ec2_transit_gateway.this.id
#   vpc_id             = aws_vpc.this.id
# }
# resource "aws_ec2_transit_gateway_vpc_attachment" "private_sn_az1_attachment" {
#   subnet_ids         = [aws_subnet.private_sn_az1.id]
#   transit_gateway_id = aws_ec2_transit_gateway.this.id
#   vpc_id             = aws_vpc.this.id
# }
# resource "aws_ec2_transit_gateway_vpc_attachment" "private_sn_az2_attachment" {
#   subnet_ids         = [aws_subnet.private_sn_az2.id]
#   transit_gateway_id = aws_ec2_transit_gateway.this.id
#   vpc_id             = aws_vpc.this.id
# }

resource "aws_ec2_transit_gateway_route" "public_sn_az1_to_private_sn_az1_route" {
  destination_cidr_block        = aws_subnet.private_sn_az1.cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.private_sn_az1_attachment.id
}
resource "aws_ec2_transit_gateway_route" "public_sn_az1_to_private_sn_az2_route" {
  destination_cidr_block        = aws_subnet.private_sn_az1.cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.private_sn_az1_attachment.id
}
*/