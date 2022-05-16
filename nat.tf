# Creating Elastic IP for Nat Gateway

resource "aws_eip" "nat_eip" {
	vpc = true
	depends_on    = [aws_internet_gateway.igw]
	tags= {
 	  Name = "NAT Gateway EIP"	
	}	
}

# Creating NAT Gateway for samp_vpc

resource "aws_nat_gateway" "nat-gw" {
	allocation_id = aws_eip.nat_eip.id
	subnet_id 	  = aws_subnet.public_subnet.id
	
	tags = {
	  Name = "samp_vpc Nat Gateway"
	}
}

# Create routes for VPC
resource "aws_route_table" "private_rt" {
	vpc_id = aws_vpc.samp_vpc.id
	route {
	  cidr_block     = "0.0.0.0/0"
   	  nat_gateway_id = aws_nat_gateway.nat-gw.id
	}
	tags = {
	  Name = "Private Route Table"
	}
}

# Creating route associations for private Subnets

resource "aws_route_table_association" "private" {
	subnet_id      = aws_subnet.private_subnet.id
	route_table_id = aws_route_table.private_rt.id
}

