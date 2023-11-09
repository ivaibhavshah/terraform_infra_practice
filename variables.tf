variable "region" {
  description = "AWS Deployment region.."
  default     = "ap-south-1"
}
variable "sql_username" {
  description = "The username for the DB master user"
  type        = string
}
variable "sql_password" {
  description = "The password for the DB master user"
  type        = string
} 
