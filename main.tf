terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

#Create the VPC
resource "aws_vpc" "david-vpc-test-001" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "david-vpc-test-001"
  }
}

#Create internet gateway
resource "aws_internet_gateway" "internet-gateway-001"{
  vpc_id = aws_vpc.david-vpc-test-001.id
}

#create route table for pub subnet
resource "aws_route_table" "rt-public-001"{
  vpc_id = aws_vpc.david-vpc-test-001.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway-001.id
  }
  tags = {
    Name = "public-rt-001"
  }
}

#create Public subnet
resource "aws_subnet" "david-pub-subnet-test-001" {
  vpc_id = aws_vpc.david-vpc-test-001.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true" #makes this public subnet
  availability_zone = "us-east-1a"
  tags = {
    Name = "david-pub-subnet-001"
  }	
}

#associate public subnet with route table
resource "aws_route_table_association" "pub-subnet-rt-001"{
  subnet_id = aws_subnet.david-pub-subnet-test-001.id
  route_table_id = aws_route_table.rt-public-001.id
}

#create Elastic IP
resource "aws_eip" "eip-nat-001"{
  vpc = true
  tags = {
    Name = "test-eip-001"
  }
}

#create NAT Gateway
resource "aws_nat_gateway" "nat-gateway-001"{
  allocation_id = aws_eip.eip-nat-001.id
  subnet_id = aws_subnet.david-priv-subnet-test-001.id
}

#create route table for private subnet
resource "aws_route_table" "priv-rt-001" {
  vpc_id = aws_vpc.david-vpc-test-001.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-001.id
  }
  tags = {
    Name = "private-rt-001"
  }
}

#create private subnet
resource "aws_subnet" "david-priv-subnet-test-001" {
  vpc_id = aws_vpc.david-vpc-test-001.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "david-priv-subnet-001"
  }
}

#associate private subnet with route table
resource "aws_route_table_association" "priv-subnet-rt-001" {
  subnet_id = aws_subnet.david-priv-subnet-test-001.id
  route_table_id = aws_route_table.priv-rt-001.id
}