provider "aws" {
    region  = "ap-south-1"
   
}

resource "aws_instance" "demo-karthikserver" {
    ami           = "ami-02b8269d5e85954ef"
    instance_type = "t2.micro"
    key_name      = "VPC-DEMO" # Ensure this key pair exists in your AWS account
   vpc_security_group_ids = [aws_security_group.allow_ssh.id]
   subnet_id = aws_subnet.demo-public-subnet-01.id
   for_each = toset(["Jenkins-master","Jenkins-slave","ansible"])

    tags = {
        Name = "Demo-server"
    }
}
    

resource "aws_security_group" "allow_ssh" {
  name_prefix  = "allow_ssh"
  description  = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id = aws_vpc.demo_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace <YOUR_PUBLIC_IP> with your actual public IP address
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc" "demo_vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "demo_vpc"
    }
}

resource "aws_subnet" "demo-public-subnet-01" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "demo-public-subnet-01"
    }
}

resource "aws_subnet" "demo-public-subnet-02" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"
    tags = {
        Name = "demo-public-subnet-02"
    }
}

resource "aws_internet_gateway" "demo-igw" {
    vpc_id = aws_vpc.demo_vpc.id
    tags = {
        Name = "demo-igw"
    }
}

resource "aws_route_table" "demo-public-rt" {
    vpc_id =aws_vpc.demo_vpc.id
    route {
        cidr_block="0.0.0.0/0"
        gateway_id =aws_internet_gateway.demo-igw.id
    }
}

resource "aws_route_table_association" "demo-rta-public-subnet-01" {
    subnet_id = aws_subnet.demo-public-subnet-01.id
    route_table_id = aws_route_table.demo-public-rt.id
}

resource "aws_route_table_association" "demo-rta-public-subnet-02" {
    subnet_id = aws_subnet.demo-public-subnet-02.id
    route_table_id = aws_route_table.demo-public-rt.id
}