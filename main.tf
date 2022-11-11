terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

# Configure provider
provider "aws" {
  region  = "ap-south-1"
}

# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name        = "vpc-project"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name        = "ig-project"
  }
}

#public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

#route table

resource "aws_route_table" "project_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
    tags = {
    Name = "project-rt"
  }
}

# Associate public subnets with route table

resource "aws_route_table_association" "public_route_1" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.project_rt.id
}

# Create security groups
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow web and ssh traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}

# Create ebs volume attachement

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.vole.id
  instance_id = aws_instance.web1.id
}

# Create ec2 instances

resource "aws_instance" "web1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name          = "jenkins"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  user_data = <<EOF
      
      #!/bin/bash
      echo "#!/bin/bash 
      init 0" >> /test.sh
      chmod 777 /test.sh
      crontab -l > /tmp/mycrontab
      echo '5 * * * * /bin/bash /root/test.sh' >> /tmp/mycrontab
      crontab /tmp/mycrontab
      timedatectl set-timezone Asia/Kolkata
      init 6

      EOF
 
  tags = {
    Name = "NewTerraform"
  }
}  

# Create ebs volume

  resource "aws_ebs_volume" "vole" {
    availability_zone = "ap-south-1a"
    size              = 40

    tags = {
      Name = "HelloWorld"
    }
  }
 
 # ebs volume encryption
  resource "aws_ebs_encryption_by_default" "example" {
    enabled = true
  }
