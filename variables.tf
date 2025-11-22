#### Project ####
variable "project_name" {
    type = string
  
}

variable "environment" {
    type = string
    default = "dev"
}

variable "common_tags" {
    type = map(string)
    
}

#### VPC ####
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "vpc_tags" {
    type = map(string)
    default = {}
  
}

#### IGW ####
variable "igw_tags" {
    type = map(string)
    default = {}
  
}

#### ElasticIP ####
variable "eip_tags" {
    type = map(string)
    default = {}
  
}

#### public subnets ####
variable "public_subnets_cidrs" {
    type = list(string)
    validation {
        condition     = length(var.public_subnets_cidrs) == 2
        error_message = "Mandatorly Provide 2 subnet cidr values"
    }
}

variable "public_subnet_tags" {
    type = map(string)
    default = {}
  
}

#### private subnets ####
variable "private_subnets_cidrs" {
    type = list(string)
    validation {
        condition     = length(var.private_subnets_cidrs) == 2
        error_message = "Mandatorly Provide 2 subnet cidr values"
    }
}

variable "private_subnet_tags" {
    type = map(string)
    default = {}
  
}


#### database subnets ####
variable "database_subnets_cidrs" {
    type = list(string)
    validation {
        condition     = length(var.database_subnets_cidrs) == 2
        error_message = "Mandatorly Provide 2 subnet cidr values"
    }
}

variable "database_subnet_tags" {
    type = map(string)
    default = {}
  
}

#### database subnet group rule ####
variable "database_subnet_group_tags" {
    type = map(string)
    default = {}
  
}


#### NAT gate way tags ####
variable "natgw_tags" {
    type = map(string)
    default = {}
  
}

#### public_route_table ####
variable "public_route_table_tags" {
    type = map(string)
    default = {}
  
}



#### private_route_table ####
variable "private_route_table_tags" {
    type = map(string)
    default = {}
  
}

#### database_route_table ####
variable "database_route_table_tags" {
    type = map(string)
    default = {}
  
}


#### vpc peering ####

variable "is_peering_required" {
    type = bool
    default = "false"
  
}

variable "peering_tags" {
    type = map(string)
    default = {}
  
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
  
}