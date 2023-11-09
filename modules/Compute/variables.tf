variable "ecs_cluster_name" {
    description = "Name of ECS Cluster"
}
variable "vpc_id" {
  description = "vpc id created in networking"
}

variable "private_subnet_id" {
  description = "Private subnet id from networks"
}
variable "public_subnet_id" {
  description = "Private subnet id from networks"
}
variable "image_mutability" {}
variable "ecr_name" {}
variable "project_name" {}
variable "container_port" {
  default = 80
}
variable "desired_count" {
  default = 2
}
variable "service_name" {}
variable "container_memory" {
  description = "Container memory limit in mb"
  default = 512
}
variable "container_cpu" {
  description = "Container cpu limit"
  default = 256
}
variable "host_port" {
  default = 80 
}
variable "load_balancer_listener_port" {
  default = 80
}