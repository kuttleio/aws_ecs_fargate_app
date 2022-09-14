variable vpc_id {}
variable subnets {}
variable name_prefix {}
variable domain_name {}
variable ecr_region {}
variable ecr_account_id {}
variable security_groups {}
variable aws_lb_certificate_arn {}
variable logdna_lambda_logs_arn {}

variable service_discovery_id {
  type    = string
  default = ""
}

variable aws_lb_arn {
  type    = string
  default = ""
}

variable image_name {
  type    = string
  default = "nginx"
}
variable image_version {
  type    = string
  default = "latest"
}
variable service_image {
  type        = string
  default     = null
  description = "Full ECR Url. Example: 000000000000.dkr.ecr.us-west-2.amazonaws.com/repo_name:image_version"
}
variable wenv {
  type    = string
  default = "fargate"
}
variable standard_tags {
  type        = map(string)
  description = "Tags"
}
variable cluster_name {
  type        = string
  default     = "fargate"
  description = "ECS Cluster name"
}
variable service_name {
  type        = string
  default     = "fargate"
  description = "ECS Service name. Better to use with prefix"
}
variable container_cpu {
  type        = number
  default     = 256
  description = "Container vCPU. 256 = 0.25 vCPU | 1024 = 1.0 vCPU | 4096 = 4.0 vCPU (max)"
}
variable container_memory {
  type        = number
  default     = 512
  description = "Container Memory (RAM). 512 = 512 Mb | 1024 = 1024 Mb = 1.0 Gb | 8192 = 8192 Mb = 8.0 Gb (max)"
}
variable task_cpu {
  type        = number
  default     = 256
  description = "Task vCPU. 256 = 0.25 vCPU | 1024 = 1.0 vCPU | 4096 = 4.0 vCPU (max)"
}
variable task_memory {
  type        = number
  default     = 512
  description = "Task Memory (RAM). 512 = 512 Mb | 1024 = 1024 Mb = 1.0 Gb | 8192 = 8192 Mb = 8.0 Gb (max)"
}
variable service_port {
  type        = number
  default     = 8080
  description = "Container port. It is fine to leave the default value"
}
variable external_port {
  type        = number
  default     = 443
  description = "You do not need to specify it"
}
variable entrypoint {
  type    = list(string)
  default = null
}
variable command {
  type        = list(string)
  default     = null
  description = "Commands to run on launch"
}
variable desired_count {
  type    = number
  default = 1
}
variable max_capacity {
  type    = number
  default = 1
}
variable min_capacity {
  type    = number
  default = 1
}
variable container_cpu_low_threshold {
  type    = number
  default = 60
}
variable container_cpu_high_threshold {
  type    = number
  default = 30
}
variable task_role_arn {
  type        = string
  default     = null
  description = "Task Role ARN"
}
variable health_check_grace_period_seconds {
  type        = number
  default     = null
  description = "Set 300 if your container needs to build / initialize something on launch"
}
variable additional_containers {
  description = "Additional containers definition"
  default     = []
}
variable public {
  type        = bool
  default     = false
  description = "Set as true to use with public load balancer"
}
variable launch_type {
  default = "FARGATE"
}
variable retention_in_days {
  type        = number
  default     = 7
  description = "Amount of days to store service logs"
}

variable mount_points {
  type = list(object({
    containerPath = string
    sourceVolume  = string
    readOnly      = bool
  }))
  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`"
  default     = []
}

variable volumes {
  type = list(object({
    name = string
    efs_volume_configuration = list(object({
      file_system_id = string
      root_directory = string
    }))
  }))
  description = "Task volume definitions as list of configuration objects"
  default     = []
}

variable environment {
  type = list(object({
    name  = any
    value = any
  }))
  description = "List of Environment Variables"
  default     = []
}

variable secrets {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  description = "List of Secrets"
  default     = []
}
