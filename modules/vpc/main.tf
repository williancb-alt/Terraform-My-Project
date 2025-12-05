# Creates a VPC named "multi-az-vpc" with IP address range 10.0.0.0/16, serving as the isolated virtual network container
# for all subnets, EC2 instances, ALB, and NAT Gateway.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "multi-az-vpc" }
}

# Creates multiple public subnets across AZs in the VPC, enabling ALB that need public internet access
# map_public_ip_on_launch = true: Automatically assigns public IPs to EC2 instances launched, 
# essential for ALB/internet-facing resources
resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.${1+count.index}.0/24"
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "public-${count.index + 1}", Type = "Public" }
}

# Creates multiple private subnets across AZs in the VPC, providing secure locations for EC2 instances 
# that shouldn't have direct public internet access.
resource "aws_subnet" "private" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.${3+count.index}.0/24"   # 10.0.3.0/24, 10.0.4.0/24
  availability_zone = var.availability_zones[count.index]
  tags = { 
    Name = "private-${count.index + 1}"
    Type = "Private" 
  }
}

# Internet Gateway - public internet access for ALB
resource "aws_internet_gateway" "igw" { vpc_id = aws_vpc.main.id }

# Creates a NAT Gateway in a public subnet with an Elastic IP, enabling outbound internet access for private subnet EC2 instances 
# like ASG while blocking inbound internet traffic.
resource "aws_eip" "nat" { domain = "vpc" }
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id
}

# Create a public route table for the VPC and associate it with all public subnets, enabling full bidirectional internet access 
# for ALB and NAT Gateway via the Internet Gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  # Adds default route sending all traffic through the Internet Gateway, making subnets public.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id 
  }
}
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  #Applies internet routing to public subnets
  route_table_id = aws_route_table.public.id
}

# Creates a private route table for the VPC and associate it with all private subnets
# enabling outbound internet access for EC2 instances in private subnets via a NAT Gateway (no inbound internet access)

# Route { cidr_block = "0.0.0.0/0", nat_gateway_id = aws_nat_gateway.nat.id }: Adds default route sending all outbound traffic 
# (internet) through the NAT Gateway for private subnet instances to reach external services (updates, yum, etc.)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id 
  }
}

# count = length(aws_subnet.private): Creates one association per private subnet (handles multiple AZs).​
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Expose key resource IDs to the parent/root module, enabling other modules (alb, ec2) to reference 
# them via module.vpc.vpc_id, module.vpc.public_subnets, etc.
output "vpc_id" { value = aws_vpc.main.id }
output "public_subnets" { value = aws_subnet.public[*].id }
output "private_subnets" { value = aws_subnet.private[*].id }
