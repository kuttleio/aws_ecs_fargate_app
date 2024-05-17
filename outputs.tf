output service_port {
  value       = var.service_port
  description = "Service port"
}

output service_name {
  value       = aws_ecs_service.main.name
  description = "Service name"
}
