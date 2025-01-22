output "db_sg" {
  value = aws_security_group.this.id
}

output "rw_endpoint" {
  value = aws_rds_cluster.this.endpoint
}