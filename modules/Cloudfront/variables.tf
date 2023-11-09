variable "alb_dns_name" {
  
}
variable "price_class" {
 default = "PriceClass_100" 
}
variable "aliases" {
  default = []
}
variable "origin_protocol_policy" {
  default = "match-viewer"
}
variable "viewer_protocol_policy" {
  default = "allow-all"
}
variable "caching_policy" {
  default = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
}
variable "origin_request_policy" {
  default = "216adef6-5c7f-47e4-b989-5492eafa07d3"
}
variable "web_acl_arn" {
  
}
