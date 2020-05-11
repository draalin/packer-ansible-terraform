data "aws_availability_zones" "az" {}

provider "aws" {
  region = var.region
}

data "aws_ami" "image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["web-ami"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "subnet" {
  count             = var.instances
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-igw"
  }
}

resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "${var.project}-nat-eip"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id

  subnet_id = "${aws_subnet.subnet[0].id}"
}

resource "aws_security_group" "sg" {
  name        = "${var.project}-sg"
  description = "This is for ${var.project}s security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.project}-sg"
  }
}

resource "aws_security_group_rule" "rule" {
  count             = length(var.port_number)
  type              = "ingress"
  from_port         = var.port_number[count.index]
  to_port           = var.port_number[count.index]
  protocol          = "tcp"
  cidr_blocks       = var.sg_source
  security_group_id = aws_security_group.sg.id
  description       = "rule-${count.index} port-${var.port_number[count.index]}"
}

resource "aws_key_pair" "key" {
  key_name   = "${var.project}-key"
  public_key = "${file("${var.ssh_key}")}"
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.image.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet[0].id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  tags = {
    Name = "${var.project}-ec2"
  }
}
