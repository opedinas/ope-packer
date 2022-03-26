
# Internet VPC

resource "aws_vpc" "opedinasvpc" {
 cidr_block          = "10.0.0.0/16"
 instance_tenancy    = "default"
 enable_dns_support  = "true"
 enable_hostnames    = "true"
 enable_classiclink  = "false"
 tags = {
   name = "opedinasmain"
 }

}

#subnet
resource "aws_subnet" "opedinasvpc-public-1" {
 vpc_id                  = aws_vpc.opedinasvpc.id
 cidr_block              = "10.0.1.0/24"
 map_public-ip_on_launch ="true"
 availability_zone       = "us-east-1a"

 tags = {
   Name =" opedinasvpc-public-1"
 }
}

resource "subnet" "opedinasvpc-public -2" {
  vpc_id                 = aws_vpc.opedinasvpc.id
  cider_block            = "10.0.2.0/24"
  map_public_ip_on_lunch = "true"
  availability_zone      = "us-east-1b"
  
  tags = {
  Name = "opedinasvpc-public-2"
  }
}

resource "aws_subnet" "opedinasvpc-public-3" {
 vpc_id                  = aws_vpc.opedinasvpc.id
 cidr_block              = "10.0.3.0/24"
 map_public_ip_on_launch = "true"
 availability_zone       = "us-east-1c"

 tags = {
   Name = "opedinasvpc-public-3"
  }
}

resource "aws_subnet" "opedinaspvc-private-1" {
 vpc_id                  = aws_vpc.opedinasvpc.id
 cidr_block              = "10.0.4.0/24"
 map_public_ip_on_launch = "false"
 availability-zone       = "us-east-1a"
 
 tags = {
Name = "opedinasvpc-private-1"
  }
}

resource "aws_subnet" "opedinaspvc-private-2"{
 vpc_id                         = aws-vpc.opedinasvpc.id
 cidr_block                     = "10.0.5.0/24"
 map_public_ip_on_ launch       = "false"
 availability_zone              =  "us-east-1b"

 tags = {
 Name = "opedinaspvc-private-2"
  }
}

resource "aws_vpc" "opedinasvpc-private-3"
 vpc_id                      = aws_vpc.opedinasvpc.id
 cidr_block                  = "10.0.6.0/24"
 map_public_ip_on_launch     = "false"
 availability_zone           = "us-east-1c"

 tags = {
 Name = "opedinasvpc-private-3"
  
 }
}


# Internet GW
resource "aws_internet_gateway" "opedinas-gw" {
 vpc_id = aws_vpc.opedinasvpc.id

tags = {
 Name = "opedinasgw"
 }
}

# route tables
resource "aws_route_table" "opedinasrt-public" {
 vpc_id = aws_vpc.opedinasvpc.id
 route { 
 cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.opedinas-gw.id
 }

  tags = {
  Name = "opedinasrt-public-1"
  }
}
 
# route associations public
 resource "aws_route_table_association" "opedinas-public-1-a" {
  subnet_id          = aws_subnet.opedinasvpc-public-1.id
  route_table_id     = aws_route_table.opedinasrt-public.id
}

resource "aws_route_table_association" "opedinas-public-2-a" {
 subnet_id   = aws_subnet.opedinasvpc-public-2.id
 route_table_id = aws_route_table.opedinasrt-public.id
}

resource "aws_route_table_association" "opedinas-public-3-a" {
 subnet_id   = aws_subnet.opedinasvpc-public-3.id
 route_table_id = aws_route_table.opedinasrt-public.id
}

# nat gw
resource "aws_eip" "nat" {
 vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
 allocation_ id = aws_eip.nat.id 
 subnet_id      = "aws_subnet.opedinasvpc-public-1.id"
 depends_on     = [aws_internet_gateway.opedinas-gw]
}

#VPC setup for NAT
 resource "aws_route_table" "opedinasrt-private" {
 vpc_id   = aws_vpc.opedinasvpc.id
 route {
  cidr_block     = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat-gw.id
 }

  tags = { 
  Name = "opedinasrt-private-1"

# route associations private
resource "aws_route_table_association" "opedinasvpc-private-1-a" {
  subnet_id      = aws_subnet.opedinasvpc-private-1.id
  route_table_id = aws_route_table.opedinasrt-private.id
}

resource "aws_route_table_association" "opedinasvpc-private-2-a" {
  subnet_id      = aws_subnet.opedinasvpc-private-2.id
  route_table_id = aws_route_table.opedinasrt-private.id
}

resource "aws_route_table_association" "opedinasvpc-private-3-a" {
  subnet_id      = aws_subnet.opedinasvpc-private-3.id
  route_table_id = aws_route_table.opedinasrt-private.id
