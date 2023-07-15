
variable "services" {
  description = "Services to be deployed"
  type        = map(any)
  default     = {}
}

locals {
  services_input = {
    "frontend" = {
      public                 = true
      service_image          = "${var.ecr_repository_url}:frontend"
      container_cpu          = var.frontend_container_cpu
      container_memory       = var.frontend_container_memory
      aws_lb_arn             = var.frontend_aws_lb_arn
      aws_lb_certificate_arn = var.aws_lb_certificate_arn
      environment            = setunion(var.envvars, local.added_env)
    }
    "backend" = {
      public                 = true
      service_image          = "${var.ecr_repository_url}:backend"
      container_cpu          = var.backend_container_cpu
      container_memory       = var.backend_container_memory
      aws_lb_arn             = var.backend_aws_lb_arn
      aws_lb_certificate_arn = var.aws_lb_certificate_arn
      environment = setunion(var.envvars, local.added_env, [
        {
          name  = "UPDATE_STATUSES_CRON"
          value = "*/10 * * * *"
        },
        {
          name  = "IS_WORKER"
          value = "1"
        },
      ])
    }
    "runner" = {
      public               = false
      service_image        = "${var.ecr_repository_url}:runner"
      container_cpu        = var.runner_container_cpu
      container_memory     = var.runner_container_memory
      service_discovery_id = var.service_discovery_id
      environment          = setunion(var.envvars, local.added_env)
    }
  }

  added_env = [{
    "name"  = "key"
    "value" = "value"
  }]
}

locals {
  default_values = {
    name_prefix          = var.name_prefix
    standard_tags        = var.standard_tags
    cluster_name         = var.cluster_name
    zenv                 = var.zenv
    vpc_id               = var.vpc_id
    security_groups      = var.security_groups
    subnets              = var.private_subnets
    ecr_account_id       = var.account_id
    ecr_region           = var.ecr_region
    logs_destination_arn = var.logs_destination_arn
    domain_name          = var.domain_name
    task_role_arn        = var.task_role_arn
    secrets              = var.secrets
  }
  services = {
    for service_name, service in local.services_input : service_name => merge(merge(local.default_values, service), {
      service_name = service_name
    })
  }
}

output "test" {
  value = local.services
}

# module "service" {
#   for_each               = local.services
#   source                 = "github.com/kuttleio/aws_ecs_fargate_app?ref=1.1.1"
#   public                 = each.value.public
#   service_name           = each.value.service_name
#   service_image          = each.value.service_image
#   name_prefix            = each.value.name_prefix
#   standard_tags          = each.value.standard_tags
#   cluster_name           = each.value.cluster_name
#   zenv                   = each.value.zenv
#   container_cpu          = each.value.container_cpu
#   container_memory       = each.value.container_memory
#   vpc_id                 = each.value.vpc_id
#   security_groups        = each.value.security_groups
#   subnets                = each.value.private_subnets
#   ecr_account_id         = each.value.account_id
#   ecr_region             = each.value.ecr_region
#   aws_lb_arn             = try(each.value.aws_lb_arn, "")
#   aws_lb_certificate_arn = try(each.value.aws_lb_certificate_arn, "")
#   service_discovery_id   = try(each.value.service_discovery_id, "")
#   logs_destination_arn   = each.value.logs_destination_arn
#   domain_name            = each.value.domain_name
#   task_role_arn          = each.value.task_role_arn
#   secrets                = each.value.secrets
#   environment            = each.value.environment
# }