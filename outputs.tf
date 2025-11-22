output "az_info" {
    value = data.aws_availability_zones.available.names
}

output "default_vpc" {
    value = data.aws_vpc.default.id
  
}

output "main_vpc_id" {
    value = aws_vpc.main.id
  
}

output "public_subnet_ids" {
    value = aws_subnet.public_subnets[*].id
  
}

output "private_subnet_ids" {
    value = aws_subnet.private_subnets[*].id
  
}

output "database_subnet_ids" {
    value = aws_subnet.database_subnets[*].id  
}


output "database_subnet_group_ids" {
    value = aws_db_subnet_group.default.id
  
}

output "database_subnet_group_name" {
    value = aws_db_subnet_group.default.name
  
}

