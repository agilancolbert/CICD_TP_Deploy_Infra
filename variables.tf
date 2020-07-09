variable "region"{
  default = "eu-west-1"
}

variable "env" {
  type    = string
  default = "dev"
}



############# VPC
 
variable "cidr_block_vpc" {
  type= string
  default= "10.0.0.0/16"
}
variable "enable_dns_support"{
type = string
default = "true"
}  

variable "enable_dns_hostnames"{
type = string
default = "true"
} 

variable "enable_classiclink"{
type = string
default = "false"
} 




#  Subnets
##  Public
###  AZ1

variable "cidr_block_spb1" {
  type= string
  default= "10.0.1.0/24"
}

variable "map_public_ip_on_launch_spb1" {
  type = string
  default ="true"
}

variable "availability_zone_spb1" {
  type = string
  default = "eu-west-1a"
}



### AZ2

variable "cidr_block_spb2" {
  type= string
  default= "10.0.2.0/24"
}

variable "map_public_ip_on_launch_spb2" {
  type = string
  default ="true"
}

variable "availability_zone_spb2" {
  type = string
  default = "eu-west-1b"
}

### AZ3

variable "cidr_block_spb3" {
  type= string
  default= "10.0.3.0/24"
}

variable "map_public_ip_on_launch_spb3" {
  type = string
  default ="true"
}

variable "availability_zone_spb3" {
  type = string
  default = "eu-west-1c"
}



## Private
### AZ1

variable "cidr_block_spr1" {
  type= string
  default= "10.0.4.0/24"
}

variable "map_public_ip_on_launch_spr1" {
  type = string
  default ="false"
}

variable "availability_zone_spr1" {
  type = string
  default = "eu-west-1a"
}


### AZ2

variable "cidr_block_spr2" {
  type= string
  default= "10.0.5.0/24"
}

variable "map_public_ip_on_launch_spr2" {
  type = string
  default ="false"
}

variable "availability_zone_spr2" {
  type = string
  default = "eu-west-1b"
}


### AZ3

variable "cidr_block_spr3" {
  type= string
  default= "10.0.6.0/24"
}

variable "map_public_ip_on_launch_spr3" {
  type = string
  default ="false"
}

variable "availability_zone_spr3" {
  type = string
  default = "eu-west-1c"
}



# Nat Instance


variable ami   {
  type = string
  default = "ami-0f630a3f40b1eb0b8"
}


variable "source_dest_check" {
  type = string
  default = "false"
}    

 
# Nat SG

variable "name"{
  type = string
  default = "allow_web"
}        

# Route Table
## Private
### Use Main Route Table

variable "cidr_block_main_pri"{
  type =string
  default = "0.0.0.0/0"
}  

 
## Public

variable "cidr_block_pub"{
  type =string
  default = "0.0.0.0/0"
} 
