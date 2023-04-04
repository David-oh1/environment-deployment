variable "my-ip" {
  description = "my IP address"
}
# Create a security group that allows incoming traffic from just my IP on port range 0 to 3789
resource "aws_security_group" "sg-elb-001" {
  vpc_id = aws_vpc.david-vpc-test-001.id
  ingress {
    from_port   = 0
    to_port     = 3789
    protocol    = "tcp"
    cidr_blocks = ["${var.my-ip}/32"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
  }
  tags = {
    Name = "sg-elb-001"
  }
}

#Create classic LB that listens on port 3789 sends traffic to Priv EC2 on port 3100
resource "aws_elb" "clb-test-001" {
  name = "clb-test-001"
  #availability_zones = ["us-east-1a", "us-east-1b"]
  
  listener {
    lb_port           = 3789
    lb_protocol       = "tcp"
    instance_port     = 3100
    instance_protocol = "tcp"
  }
  instances = [aws_instance.app_server.id]
  security_groups = [aws_security_group.sg-elb-001.id]
  subnets = [aws_subnet.david-pub-subnet-test-001.id]
  tags = {
    Name = "classic-load-balancer-001"
  }
}

# Create a security group for the private instance that allows inbound traffic from classic load balancer 
resource "aws_security_group" "sg-private-instance-001" {
  vpc_id = aws_vpc.david-vpc-test-001.id
  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    security_groups = [aws_security_group.sg-elb-001.id]
  }
  tags = {
    Name = "sg-private-instance-001"
    }
}

#Create a private ec2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.david-priv-subnet-test-001.id
  vpc_security_group_ids = [aws_security_group.sg-private-instance-001.id]
  tags = {
    Name = "Terraform-instance-private-001"
 }
  user_data = file("${path.module}/index.js")
}