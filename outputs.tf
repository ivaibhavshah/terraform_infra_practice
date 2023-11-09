output "alb_dns_name" {
  value = module.Compute.alb_dns_name
}
output "cloudfront_dns"{
  value = terraform.workspace =="prod" ? module.Cloudfront[0].cf_domain_name : null

}
output "private_subnet_id" {
  value = module.Networking.private_subnet_id
}