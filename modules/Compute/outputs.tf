output "security_group_id"{
  value = "${aws_security_group.my_security_group.id}"
}
output "alb_dns_name" {
  value = aws_lb.ecs_alb.dns_name
}
output "ecs_alb_listener"{
  value = ["${aws_lb_listener.ecs_alb_listener1.arn}"]
}
output "ecs_tg_blue" {
  value = aws_lb_target_group.ecs_tg[0].name
}

output "ecs_tg_green" {
  value = aws_lb_target_group.ecs_tg[1].name
}