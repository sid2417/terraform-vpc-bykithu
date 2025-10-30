
#### vpc ######
resource "aws_vpc" "main" {
    cidr_block       = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = merge(var.common_tags,
        var.vpc_tags,
        {Name = local.resource_name}  ## morrisons-dev
        )
}

#### igw ######
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags,
        var.igw_tags,
        {Name = local.resource_name}  ## morrisons-dev
        )
}

#### public subnets ####
resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnets_cidrs)
    vpc_id     = aws_vpc.main.id
    map_public_ip_on_launch = true  ### Generally it is false, true means allowing public ips
    cidr_block = var.public_subnets_cidrs[count.index]
    availability_zone = local.availability_zones[count.index]
    tags = merge(var.common_tags,
        var.public_subnet_tags,
        {
            Name = "${local.resource_name}-public-${local.availability_zones[count.index]}"
        }   ## morrisons-dev-public-zone_name
        )
}


#### private subnets ####
resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnets_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.private_subnets_cidrs[count.index]
    availability_zone = local.availability_zones[count.index]
    tags = merge(var.common_tags,
        var.private_subnet_tags,
        {
            Name = "${local.resource_name}-private-${local.availability_zones[count.index]}"
        }   ## morrisons-dev-public-zone_name
        )
}


#### database subnets ####
resource "aws_subnet" "database_subnets" {
    count = length(var.database_subnets_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.database_subnets_cidrs[count.index]
    availability_zone = local.availability_zones[count.index]
    tags = merge(var.common_tags,
        var.database_subnet_tags,
        {
            Name = "${local.resource_name}-database-${local.availability_zones[count.index]}"
        }   ## morrisons-dev-public-zone_name
        )
}


#### Elastic IP ####
resource "aws_eip" "nat_eip" {
  domain   = "vpc"
  tags = merge(var.common_tags,
        var.eip_tags,
        {Name = local.resource_name}  ## morrisons-dev
        )
}


#### nat gateway ####
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnets[0].id #aws_subnet.public_subnets.id

    tags = merge(var.common_tags,
        var.natgw_tags,
        {Name = local.resource_name}  ## morrisons-dev
        )

    # To ensure proper ordering, it is recommended to add an explicit dependency
    # on the Internet Gateway for the VPC.
    depends_on = [aws_internet_gateway.gw]  # this is explicit dependency
}


#### Route Tables ####

#### public route table ####
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main.id
    tags = merge(var.common_tags,
        var.public_route_table_tags,
        {Name = "${local.resource_name}-public"}  ## morrisons-dev-public
        )
}

#### private route table ####
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.main.id
    tags = merge(var.common_tags,
        var.private_route_table_tags,
        {Name = "${local.resource_name}-private"}  ## morrisons-dev-private
        )
}

#### database route table ####
resource "aws_route_table" "database_route_table" {
    vpc_id = aws_vpc.main.id
    tags = merge(var.common_tags,
        var.database_route_table_tags,
        {Name = "${local.resource_name}-database"}  ## morrisons-dev-database
        )
}


#### Routes ####

#### public routes ####
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

#### private routes ####
resource "aws_route" "private_route_nat" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}

#### database routes ####
resource "aws_route" "database_route_nat" {
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}


#### Route Table Association with Subnets ####
#### public route table association with public subnet ####
resource "aws_route_table_association" "public" {
    count = length(var.public_subnets_cidrs)
    subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
    route_table_id = aws_route_table.public_route_table.id
   
}

#### private route table association with private subnet ####
resource "aws_route_table_association" "private" {
    count = length(var.private_subnets_cidrs)
    subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
    route_table_id = aws_route_table.private_route_table.id
   
}

#### database route table association with database subnet ####
resource "aws_route_table_association" "database" {
    count = length(var.database_subnets_cidrs)
    subnet_id      = element(aws_subnet.database_subnets[*].id, count.index)
    route_table_id = aws_route_table.database_route_table.id
   
}