# Creating VPC,name, CIDR and Tags

resource "aws_vpc" "samp_vpc" {
	cidr_block           = "10.0.0.0/18"
	tags = {
	  Name = "samp_vpc"
	}
}


# Creating Public Subnets in VPC(have default route to IG)

resource "aws_subnet" "public_subnet" {
	vpc_id                  = aws_vpc.samp_vpc.id
	cidr_block              = "10.0.1.0/24"
	  map_public_ip_on_launch = "true"
  	  availability_zone       = "us-west-2c"
	tags = {
	  Name = "public_subnet"
	}
}

resource "aws_subnet" "private_subnet" {
	vpc_id                  = aws_vpc.samp_vpc.id
	cidr_block              = "10.0.2.0/24"
	  map_public_ip_on_launch = "false"
	  availability_zone       = "us-west-2c"
	tags = {
		Name = "private_subnet"
	}
}


# Creating Internet Gateway in AWS VPC

resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.samp_vpc.id
	tags = {
	  Name = "samp_vpc-IGW"
	}
}

# Creating Route Tables for Public Subnet

resource "aws_route_table" "public_rt" {
	vpc_id = aws_vpc.samp_vpc.id
	  route {
	    cidr_block = "0.0.0.0/0"
	    gateway_id = aws_internet_gateway.igw.id
	  }
	tags = {
	  Name = "Public Route Table"
	}
}


# Association between public subnet and Public Route Table

resource "aws_route_table_association" "public" {
	subnet_id      = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.public_rt.id
}

