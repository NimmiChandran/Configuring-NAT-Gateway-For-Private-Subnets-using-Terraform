# Creating Security Groups

resource "aws_security_group" "test_security_group" {
	description = "Allow limited inbound external traffic"
	vpc_id      = "${aws_vpc.samp_vpc.id}"
	name  	= "private_sg"

	ingress {
		
		protocol   = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port  = 22
		to_port    = 22
	}
	
	ingress {
		
		protocol   = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port  = 8080
		to_port    = 8080
	}

	ingress {
		
		protocol   = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port  = 443
		to_port    = 443
	}

	egress {
		
		protocol   = -1
		cidr_blocks = ["0.0.0.0/0"]
		from_port  = 0
		to_port    = 0
	}

	tags = {
	  Name = "private-ec2-sg"
	}
}

output "aws_security_gr_id" {
	value = "${aws_security_group.test_security_group.id}"
}


#Creating EC2 in Public Subnet

resource "aws_instance" "public_instance" {
	ami = "ami-0ca285d4c2cda3300"
	instance_type = "t2.micro"
	vpc_security_group_ids= ["${aws_security_group.test_security_group.id}"]
	subnet_id = "${aws_subnet.public_subnet.id}"
	key_name = "demo"
	count = 1
	associate_public_ip_address = true
	tags = {
	  Name = "public_instance"
	}
}
#Creating EC2 in Private Subnet

resource "aws_instance" "private_instance" {
	ami = "ami-0ca285d4c2cda3300"
	instance_type = "t2.micro"
	vpc_security_group_ids= ["${aws_security_group.test_security_group.id}"]
	subnet_id = "${aws_subnet.private_subnet.id}"
	key_name = "demo"
	count = 1
	associate_public_ip_address = false
	tags = {
	  Name = "private_instance"
	}
}
	
