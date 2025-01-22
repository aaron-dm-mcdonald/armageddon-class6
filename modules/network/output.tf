output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of private subnet IDs"
}


output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of public subnet IDs"
}

output "db_subnet_ids" {
  value       = aws_subnet.database[*].id
  description = "List of db subnet IDs"
}

output "db_subnet_group" {
  value       = var.num_database_subnets > 0 ? aws_db_subnet_group.database[0].name : null
  description = "The ID of the database subnet group."
}
