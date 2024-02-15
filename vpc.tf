resource "aws_vpc" "this" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
    tags = {
    Name = "tf-alb-asg"
  }
}

data "aws_availability_zones" "available" {

}
resource "aws_subnet" "private_sn_az1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
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
  availability_zone = data.aws_availability_zones.available.names[1]
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
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "public-sn-az1"
  }
}
resource "aws_subnet" "public_sn_az2" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.0.0.128/26" 
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]
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


