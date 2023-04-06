variable "my-ip" {
  description = "my IP address"
}

variable "key-name" {
  description = "AWS Key to apply to Ec2 Instance"
}

# Create a security group that allows incoming traffic from just my IP on port range 0 to 3789
resource "aws_security_group" "sg-elb-002" {
  vpc_id = aws_vpc.david-vpc-test-002.id
  ingress {
    from_port   = 3789 #0/3789 means allow from 0 TO 3789
    to_port     = 3789
    protocol    = "tcp"
    cidr_blocks = ["${var.my-ip}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-elb-002"
  }
}

#Create classic LB that listens on port 3789 sends traffic to Priv EC2 on port 3100
resource "aws_elb" "clb-test-002" {
  name = "clb-test-002"
  
  listener {
    lb_port           = 3789
    lb_protocol       = "tcp"
    instance_port     = 3100
    instance_protocol = "tcp"
  }
  instances = [aws_instance.app_server.id]
  security_groups = [aws_security_group.sg-elb-002.id]
  subnets = [aws_subnet.david-pub-subnet-test-002.id]
  tags = {
    Name = "classic-load-balancer-002"
  }
}

# Create a security group for the private instance that allows inbound traffic from classic load balancer 
resource "aws_security_group" "sg-private-instance-002" {
  vpc_id = aws_vpc.david-vpc-test-002.id
  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    security_groups = [aws_security_group.sg-elb-002.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-private-instance-002"
    }
}

#Create a private ec2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.david-priv-subnet-test-002.id
  vpc_security_group_ids = [aws_security_group.sg-private-instance-002.id]
  tags = {
    Name = "Terraform-instance-private-002"
 }
  key_name = var.key-name
  user_data = file("${path.module}/user_data.sh")
  depends_on = [aws_nat_gateway.nat-gateway-002]
}