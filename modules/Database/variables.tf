variable "mysql_identifier" {
  
}
variable "username" {
  description = "The username for the DB master user"
  type        = string
}
variable "password" {
  description = "The password for the DB master user"
  type        = string
}
variable "database_name" {
  description = "database name for aurora cluster"
  type = string
}
variable "project_name" {
  
}
variable "private_subnet_ids" {
  
}
variable "vpc_id" {
  
}
variable "vpc_cidr" {
  
}