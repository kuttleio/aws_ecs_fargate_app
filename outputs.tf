output service_port {
  value       = var.service_port
  description = "Service port"
}

output full_service_name {
  value       = aws_ecs_service.main.name
  description = "Service name"
}
