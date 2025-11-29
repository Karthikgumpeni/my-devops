provider "aws" {
    region  = "ap-south-1"
   
}

resource "aws_instance" "demo-karthikserver" {
    ami           = "ami-0d176f79571d18a8f"
    instance_type = "t2.micro"
    key_name      = "VPC-DEMO"
   security_groups = [aws_security_group.allow_ssh.name]

    tags = {
        Name = "DemoServer"
    }
}
    

resource "aws_security_group" "allow_ssh" {
  name_prefix  = "allow_ssh"
  description  = "Allow ssh inbound traffic and all outbound traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with a valid CIDR block
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

