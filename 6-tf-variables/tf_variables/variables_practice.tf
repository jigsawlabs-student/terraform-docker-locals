variable "rds_name" {
    type = string
}

output "rds_variable_name" {
  value = var.rds_name
}