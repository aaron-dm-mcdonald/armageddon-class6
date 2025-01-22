output "frontend_sg_id" {
  value = aws_security_group.frontend_sg.id
}

output "lb_dns" {
  value = aws_lb.main.dns_name
}