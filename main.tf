# ---------------------------------------------------
#    CloudWatch Log Groups
# ---------------------------------------------------
resource aws_cloudwatch_log_group ecs_group {
  name              = "${var.name_prefix}/fargate/${var.cluster_name}/${var.service_name}/"
  tags              = var.standard_tags
  retention_in_days = var.retention_in_days
}


# ---------------------------------------------------
#    ECS Service
# ---------------------------------------------------
resource aws_ecs_service main {
  name                                = "${var.name_prefix}-${var.wenv}-${var.service_name}"
  cluster                             = var.cluster_name
  propagate_tags                      = "SERVICE"
  deployment_maximum_percent          = 200
  deployment_minimum_healthy_percent  = 100
  desired_count                       = var.desired_count
  task_definition                     = aws_ecs_task_definition.main.arn
  health_check_grace_period_seconds   = var.health_check_grace_period_seconds
  tags                                = merge(var.standard_tags, tomap({ Name = var.service_name }))

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }
  
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  network_configuration {
    security_groups   = var.security_groups
    subnets           = var.subnets
  }

  dynamic load_balancer {
    for_each = var.public ? [1] : []
    content {
      target_group_arn  = aws_lb_target_group.main[0].arn
      container_name    = var.service_name
      container_port    = var.service_port
    }
  }

  dynamic service_registries {
    for_each = var.public ? [] : [1]
    content {
      registry_arn = aws_service_discovery_service.main[0].arn
    }
  }
}


# ---------------------------------------------------
#     Service Discovery
# ---------------------------------------------------
resource aws_service_discovery_service main {
  count = var.public == true ? 0 : 1
  name  = "${var.name_prefix}-${var.wenv}-${var.service_name}"
  tags  = merge(var.standard_tags, tomap({ Name = var.service_name }))

  dns_config {
    namespace_id    = var.service_discovery_id
    routing_policy  = "MULTIVALUE"

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

# ---------------------------------------------------
#     Container - Main
# ---------------------------------------------------
module main_container_definition {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  container_name                = var.service_name
  container_image               = var.service_image
  container_cpu                 = var.container_cpu
  container_memory              = var.container_memory
  container_memory_reservation  = var.container_memory
  secrets                       = var.secrets
  
  port_mappings = [
    {
      containerPort = var.service_port
      hostPort      = var.service_port
      protocol      = "tcp"
    }
  ]

  environment = setunion(var.environment,
  [
    {
      name  = "PORT"
      value = var.service_port
    },
    {
      name  = "APP_PORT"
      value = var.service_port
    },
    {
      name  = "SERVICE_PORT"
      value = var.service_port
    }    
  ])

  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null
    options = {
      "awslogs-group"         = aws_cloudwatch_log_group.ecs_group.name
      "awslogs-region"        = data.aws_region.current.name
      "awslogs-stream-prefix" = "ecs"
    }
  }
}


# ---------------------------------------------------
#     Task Definition
# ---------------------------------------------------
resource aws_ecs_task_definition main {
  family                    = "${var.name_prefix}-${var.wenv}-${var.service_name}"
  requires_compatibilities  = [var.launch_type]
  execution_role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  cpu                       = var.task_cpu > var.container_cpu ? var.task_cpu : var.container_cpu
  memory                    = var.task_memory > var.container_memory ? var.task_memory : var.container_memory
  network_mode              = "awsvpc"
  tags                      = merge(var.standard_tags, tomap({ Name = var.service_name }))
  container_definitions     = module.main_container_definition.json_map_encoded_list
  task_role_arn             = var.task_role_arn
}


# ---------------------------------------------------
#    Internal Load Balancer
# ---------------------------------------------------
resource aws_lb_target_group main {
  count                         = var.public == true ? 1 : 0
  name                          = "${var.name_prefix}-${var.wenv}-${var.service_name}-tg"
  port                          = var.service_port
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  load_balancing_algorithm_type = "round_robin"
  target_type                   = "ip"
  
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/health"
    port                = var.service_port
  }
}

resource aws_lb_listener main {
  count             = var.public == true ? 1 : 0
  load_balancer_arn = var.aws_lb_arn
  port              = var.external_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.aws_lb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
}

# ---------------------------------------------------
#    LogDNA subsciprion
# ---------------------------------------------------
resource aws_cloudwatch_log_subscription_filter lambda_logfilter {
  name            = "${var.name_prefix}-${var.wenv}-${var.service_name}-filter"
  log_group_name  = "${var.name_prefix}/fargate/${var.cluster_name}/${var.service_name}/"
  filter_pattern  = ""
  destination_arn = var.logdna_lambda_logs_arn
  distribution    = "ByLogStream"
}
