# Elastic IP for NAT gateway
resource "aws_eip" "natgw_eip_private_az1" {
  depends_on = [aws_internet_gateway.this]
  domain        = "vpc"
  tags = {
    Name = "natgw-eip-private-az1"
  }
}
resource "aws_eip" "natgw_eip_private_az2" {
  depends_on = [aws_internet_gateway.this]
  domain        = "vpc"
  tags = {
    Name = "natgw-eip-private_sn_2"
  }
}

# create NAT GW in public subnet for private subnets to reach the internet to download updates and patches
resource "aws_nat_gateway" "natgw_az1" {
  allocation_id = aws_eip.natgw_eip_private_az1.id
  subnet_id     = aws_subnet.public_sn_az1.id # nat should be in public subnet

  tags = {
    Name = "Nat Gateway for private subnet AZ1"
  }
  depends_on = [aws_internet_gateway.this]
}
resource "aws_nat_gateway" "natgw_az2" {
  allocation_id = aws_eip.natgw_eip_private_az2.id
  subnet_id     = aws_subnet.public_sn_az2.id # nat should be in public subnet

  tags = {
    Name = "Nat Gateway for private subnet AZ2"
  }
  depends_on = [aws_internet_gateway.this]
}

