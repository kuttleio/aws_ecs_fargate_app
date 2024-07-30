variable vpc_id {}
variable subnets {}
variable name_prefix {}
variable domain_name {}
variable ecr_region {}
variable ecr_account_id {}
variable security_groups {}

variable logs_destination_arn {
  type        = string
  default     = ""
  description = "ARN where you want to push the logs"
}

variable run_on_spots {
  type        = bool
  default     = true
  description = "Set true to run 100% on FARGATE_SPOT"
}

variable aws_lb_certificate_arn {
  type        = string
  default     = ""
  description = "Certificate ARN (if $public != true)"
}

variable service_discovery_id {
  type        = string
  default     = ""
  description = "Service discovery ID"
}

variable aws_lb_arn {
  type        = string
  default     = ""
  description = "Load Balancer ARN (if $public = true)"
}
variable target_group_arn {
  type        = string
  default     = ""
  description = "LB Target group ARN (if $public = true)"
}

variable image_name {
  type        = string
  default     = "nginx"
  description = "Image name"
}

variable image_version {
  type        = string
  default     = "latest"
  description = "Image version"
}

variable service_image {
  type        = string
  default     = null
  description = "Full ECR Url. Example: 000000000000.dkr.ecr.us-west-2.amazonaws.com/repo_name:image_version"
}

variable zenv {
  type        = string
  default     = "fargate"
  description = "Environment name (stack)"
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
  description = "ECS Service name. Use with prefix like: $account-$region-$name"
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
  description = "Container port. OK to use the default value"
}

variable external_port {
  type        = number
  default     = 443
  description = "No need to set it up. Used for public services (if $public = true)"
}

variable entrypoint {
  type        = list(string)
  default     = null
  description = "Just entrypoint"
}

variable command {
  type        = list(string)
  default     = null
  description = "Commands to run on launch"
}

variable desired_count {
  type        = number
  default     = 1
  description = "Desired task count"
}

variable max_capacity {
  type        = number
  default     = 1
  description = "Autoscaling: Max capacity"
}

variable min_capacity {
  type        = number
  default     = 1
  description = "Autoscaling: Min capacity"
}

variable container_cpu_low_threshold {
  type        = number
  default     = 60
  description = "Autoscaling: Low CPU Threshold"
}

variable container_cpu_high_threshold {
  type        = number
  default     = 30
  description = "Autoscaling: High CPU Threshold"
}

variable task_role_arn {
  type        = string
  default     = null
  description = "Task Role ARN"
}

variable health_check_grace_period_seconds {
  type        = number
  default     = null
  description = "Set 300 if your container needs to be initialized on launch"
}

variable health_check_path {
  type        = string
  default     = "/health"
  description = "Health checks path. Best to use the default one"
}

variable additional_containers {
  type        = list(string)
  default     = []
  description = "Additional containers definition"
}

variable public {
  type        = bool
  default     = false
  description = "Set as true to use with public load balancer"
}

variable launch_type {
  type        = string
  default     = "FARGATE"
  description = "Launch type. Just leave as FARGATE"
}

variable retention_in_days {
  type        = number
  default     = 7
  description = "How many days you want to store your logs. Mind costs."
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

variable disk_size_in_gib {
  type        = number
  description = "ECS Task ephemeral storage (in Gigs)"
  default     = 21
}

variable min_task_count {
  description = "Min number of tasks for the ECS service"
  type        = number
  default     = 0
}

variable max_task_count {
  description = "Max number of tasks for the ECS service"
  type        = number
  default     = 1
}

variable scale_cooldown {
  description = "Cooldown period for scaling in and out"
  type        = number
  default     = 300
}

variable threshold {
  description = "Threshold for SQS messages to trigger scaling"
  type        = number
  default     = 10
}

variable sqs_queue_name {
  description = "SQS name for scaling"
  type        = string
  default     = ""
}
