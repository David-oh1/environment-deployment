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

variable "public_cidr_blocks" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    0 = "10.0.1.0/20"
    1 = "10.0.2.0/20"
    2 = "10.0.3.0/20"
  }
}

variable "private_cidr_blocks" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    1 = "10.0.101.0/20"
    2 = "10.0.102.0/20"
    3 = "10.0.103.0/20"
  }
}

resource "aws_subnet" "david-pub-subnet-test-002-1" {
  count = var.subnet_count
  vpc_id = aws_vpc.david-vpc-test-002.id
  cidr_block = public_cidr_blocks[count.index]
  map_public_ip_on_launch = "true"
  availability_zone = az_list[count.index]
  tags = {
    Name = "pub-subnet-${count.index}-${var.suffix}"
  }	
}

#create Public subnet
# number of subnets created is driven by a variable min 2 / max 3
resource "aws_subnet" "david-pub-subnet-test-002-1" {
  vpc_id = aws_vpc.david-vpc-test-002.id
  cidr_block = public_cidr_blocks[1]
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "david-pub-subnet-002-1"
  }	
}

resource "aws_subnet" "david-pub-subnet-test-002-2" {
  vpc_id = aws_vpc.david-vpc-test-002.id
  cidr_block = public_cidr_blocks[2]
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "david-pub-subnet-002-1"
  }	
}

resource "aws_subnet" "david-pub-subnet-test-002-3" {
  vpc_id = aws_vpc.david-vpc-test-002.id
  cidr_block =public_cidr_blocks[3]
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