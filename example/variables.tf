
variable "name_prefix" {
  default = "prefix1"
}

variable "standard_tags" {
  default = {}
}

variable "cluster_name" {
  default = "cluster1"
}

variable "zenv" {
  default = "test"
}

variable "vpc_id" {
  default = "vpc-1234567890"
}

variable "security_groups" {
  default = ["sg-1234567890"]
}

variable "private_subnets" {
  default = ["subnet-1234567890"]
}

variable "account_id" {
  default = "1234567890"
}

variable "ecr_region" {
  default = "us-east-1"
}

variable "logs_destination_arn" {
  default = "arn:aws:logs:us-east-1:1234567890:destination:log_destination1"
}

variable "domain_name" {
  default = "example.com"
}

variable "task_role_arn" {
  default = "arn:aws:iam::1234567890:role/role1"
}

variable "secrets" {
  default = {}
}

variable "envvars" {
  default = [{ name = "test_name", value = "test_value" }]
}

variable "ecr_repository_url" {
  default = "1234567890.dkr.ecr.us-east-1.amazonaws.com"
}

variable "frontend_container_cpu" {
  default = 256
}

variable "frontend_container_memory" {
  default = 512
}


variable "frontend_aws_lb_arn" {
  default = "arn:aws:elasticloadbalancing:us-east-1:1234567890:loadbalancer/app/lb1"
}

variable "aws_lb_certificate_arn" {
  default = "arn:aws:acm:us-east-1:1234567890:certificate/cert1"
}

variable "backend_container_cpu" {
  default = 256
}

variable "backend_container_memory" {
  default = 512
}

variable "backend_aws_lb_arn" {
  default = "arn:aws:elasticloadbalancing:us-east-1:1234567890:loadbalancer/app/lb1"
}

variable "service_discovery_id" {
  default = "sd-1234567890"
}

variable "runner_container_cpu" {
  default = 256
}

variable "runner_container_memory" {
  default = 512
}