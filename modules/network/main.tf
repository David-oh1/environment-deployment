#Create the VPC
resource "aws_vpc" "david-vpc-test-002" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "david-vpc-test-002"
  }
}

#Create internet gateway
resource "aws_internet_gateway" "internet-gateway-002"{
  vpc_id = aws_vpc.david-vpc-test-002.id
}

#create route table for pub subnet
resource "aws_route_table" "rt-public-002"{
  vpc_id = aws_vpc.david-vpc-test-002.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway-002.id
  }
  tags = {
    Name = "public-rt-002"
  }
}

#create Public subnet
resource "aws_subnet" "david-pub-subnet-test-002-1" {
  vpc_id = aws_vpc.david-vpc-test-002.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "david-pub-subnet-002-1"
  }	
}


#create Public subnet
resource "aws_subnet" "david-pub-subnet-test-002-2" {
  vpc_id = aws_vpc.david-vpc-test-002.id
  cidr_block = "10.0.3.0/24" 
  map_public_ip_on_launch = "true" 
  availability_zone = "us-east-1b"
  tags = {
    Name = "david-pub-subnet-002-2"
  }	
}

#associate public subnet with route table
resource "aws_route_table_association" "pub-subnet-rt-002"{
  subnet_id = aws_subnet.david-pub-subnet-test-002.id
  route_table_id = aws_route_table.rt-public-002.id
}

#create Elastic IP
resource "aws_eip" "eip-nat-002"{
  vpc = true
  tags = {
    Name = "test-eip-002"
  }
}

#create NAT Gateway
resource "aws_nat_gateway" "nat-gateway-002"{
  allocation_id = aws_eip.eip-nat-002.id
  subnet_id = aws_subnet.david-pub-subnet-test-002.id
  depends_on = [aws_internet_gateway.internet-gateway-002]
}

#create route table for private subnet
resource "aws_route_table" "priv-rt-002" {
  vpc_id = aws_vpc.david-vpc-test-002.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-002.id
  }
  tags = {
    Name = "private-rt-002"
  }
}

#create private subnet
resource "aws_subnet" "david-priv-subnet-test-002" {
  vpc_id = aws_vpc.david-vpc-test-002.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "david-priv-subnet-002"
  }
}

#associate private subnet with route table
resource "aws_route_table_association" "priv-subnet-rt-002" {
  subnet_id = aws_subnet.david-priv-subnet-test-002.id
  route_table_id = aws_route_table.priv-rt-002.id
}