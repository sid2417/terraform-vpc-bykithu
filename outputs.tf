output "az_info" {
    value = data.aws_availability_zones.available.names
}

output "default_vpc" {
    value = data.aws_vpc.default.id
  
}


output "main_vpc_id" {
    value = aws_vpc.main.id
  
}

