# ---------------------------------------------------
# CloudWatch Log Groups
# ---------------------------------------------------
resource aws_cloudwatch_log_group ecs_group {
  name              = "${var.name_prefix}/fargate/${var.cluster_name}/${var.service_name}/"
  tags              = var.standard_tags
  retention_in_days = var.retention_in_days
}

resource time_sleep wait {
  depends_on      = [aws_cloudwatch_log_group.ecs_group]
  create_duration = "10s"
}

# ---------------------------------------------------
# Cloudwatch subscription for pushing logs
# ---------------------------------------------------
resource aws_cloudwatch_log_subscription_filter lambda_logfilter {
  depends_on      = [aws_cloudwatch_log_group.ecs_group, time_sleep.wait]
  name            = "${var.name_prefix}-${var.zenv}-${var.service_name}-filter"
  log_group_name  = "${var.name_prefix}/fargate/${var.cluster_name}/${var.service_name}/"
  filter_pattern  = ""
  destination_arn = var.logs_destination_arn
  distribution    = "ByLogStream"
}

# ---------------------------------------------------
# ECS Service
# ---------------------------------------------------
resource aws_ecs_service main {
  name                               = "${var.name_prefix}-${var.zenv}-${var.service_name}"
  cluster                            = var.cluster_name
  propagate_tags                     = "SERVICE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = var.desired_count
  task_definition                    = aws_ecs_task_definition.main.arn
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  tags                               = merge(var.standard_tags, tomap({ Name = var.service_name }))

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = var.run_on_spots == true ? 0 : 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = var.run_on_spots == true ? 1 : 0
  }

  network_configuration {
    security_groups = var.security_groups
    subnets         = var.subnets
  }

  dynamic "load_balancer" {
    for_each = var.public ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.service_name
      container_port   = var.service_port
    }
  }

  service_registries {
    registry_arn = aws_service_discovery_service.main.arn
  }
}

# ---------------------------------------------------
# Service Discovery
# ---------------------------------------------------
resource aws_service_discovery_service main {
  name = "${var.name_prefix}-${var.zenv}-${var.service_name}"
  tags = merge(var.standard_tags, tomap({ Name = var.service_name }))

  dns_config {
    namespace_id   = var.service_discovery_id
    routing_policy = "MULTIVALUE"

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
# Container - Main
# ---------------------------------------------------
module main_container_definition {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.61.1"

  container_name               = var.service_name
  container_image              = var.service_image
  container_cpu                = var.container_cpu
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory
  secrets                      = var.secrets
  command                      = var.command

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
    ]
  )

  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null
    options = {
      "awslogs-group"         = aws_cloudwatch_log_group.ecs_group.name
      "awslogs-region"        = data.aws_region.current.name
      "awslogs-stream-prefix" = "ecs"
      "mode"                  = "non-blocking"
      "max-buffer-size"       = "25m"
    }
  }
}

# ---------------------------------------------------
# Task Definition
# ---------------------------------------------------
resource aws_ecs_task_definition main {
  family                   = "${var.name_prefix}-${var.zenv}-${var.service_name}"
  requires_compatibilities = [var.launch_type]
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  cpu                      = var.task_cpu > var.container_cpu ? var.task_cpu : var.container_cpu
  memory                   = var.task_memory > var.container_memory ? var.task_memory : var.container_memory
  network_mode             = "awsvpc"
  tags                     = merge(var.standard_tags, tomap({ Name = var.service_name }))
  container_definitions    = module.main_container_definition.json_map_encoded_list
  task_role_arn            = var.task_role_arn

  ephemeral_storage {
    size_in_gib = var.disk_size_in_gib
  }
}

# ---------------------------------------------------
# Autoscaling settings
# ---------------------------------------------------
locals {
  scale_steps_temp = [
    for i in range(0, ceil(var.max_task_count / var.target_sqs_messages)) : {
      adjustment            = i + 1
      metric_lower_bound    = i * var.target_sqs_messages
      metric_upper_bound    = i < ceil(var.max_task_count / var.target_sqs_messages) - 1 ? (i + 1) * var.target_sqs_messages - 1 : null
    }
  ]
  
  has_final_step = length([for step in local.scale_steps_temp : step.metric_upper_bound == null ? 1 : 0]) > 0
  
  scale_steps = local.has_final_step ? local.scale_steps_temp : concat(local.scale_steps_temp, [{
    adjustment            = ceil(var.max_task_count / var.target_sqs_messages)
    metric_lower_bound    = ceil(var.max_task_count / var.target_sqs_messages) * var.target_sqs_messages
    metric_upper_bound    = null
  }])
}

# ---------------------------------------------------
# IAM Role for Autoscaling
# ---------------------------------------------------
resource aws_iam_role ecs_service_autoscale {
  name = "${var.name_prefix}-${var.zenv}-${var.service_name}-ecs-service-autoscale"
  tags = var.standard_tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "application-autoscaling.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource aws_iam_role_policy_attachment ecs_service_autoscale {
  role       = aws_iam_role.ecs_service_autoscale.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

# ---------------------------------------------------
# App Autoscaling Target
# ---------------------------------------------------
resource aws_appautoscaling_target ecs_service {
  count              = var.sqs_queue_name != "" ? 1 : 0
  max_capacity       = var.max_task_count
  min_capacity       = var.min_task_count
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs_service_autoscale.arn
}

# ---------------------------------------------------
# App Autoscaling Policy: Scale Out
# ---------------------------------------------------
resource aws_appautoscaling_policy scale_out {
  count              = var.sqs_queue_name != "" ? 1 : 0
  name               = "${var.name_prefix}-${var.zenv}-${var.service_name}-scale-out"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_service[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service[count.index].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_out_cooldown
    metric_aggregation_type = "Average"

    dynamic step_adjustment {
      for_each = local.scale_steps
      content {
        scaling_adjustment          = step_adjustment.value.adjustment
        metric_interval_lower_bound = step_adjustment.value.metric_lower_bound
        metric_interval_upper_bound = step_adjustment.value.metric_upper_bound
      }
    }
  }
}

# ---------------------------------------------------
# App Autoscaling Policy: Scale In
# ---------------------------------------------------
resource aws_appautoscaling_policy scale_in {
  count              = var.sqs_queue_name != "" ? 1 : 0
  name               = "${var.name_prefix}-${var.zenv}-${var.service_name}-scale-in"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_service[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service[count.index].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_in_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_upper_bound = 0
    }
  }
}

# ---------------------------------------------------
# CloudWatch Metric Alarms for SQS
# ---------------------------------------------------
resource aws_cloudwatch_metric_alarm sqs_messages_visible {
  count               = var.sqs_queue_name != "" ? 1 : 0
  alarm_name          = "${var.name_prefix}-${var.zenv}-${var.service_name}-SQS-Messages-Visible"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = var.target_sqs_messages
  alarm_description   = "Alarm if number of visible messages in SQS exceeds the threshold."
  dimensions = {
    QueueName = var.sqs_queue_name
  }
}

# ---------------------------------------------------
# CloudWatch Alarms: Scale Out
# ---------------------------------------------------
resource aws_cloudwatch_metric_alarm scale_out_alarm {
  count               = var.sqs_queue_name != "" ? 1 : 0
  alarm_name          = "${var.name_prefix}-${var.zenv}-${var.service_name}-scale-out-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = var.target_sqs_messages
  alarm_description   = "Scale out if number of visible messages in SQS exceeds the threshold."
  dimensions = {
    QueueName = var.sqs_queue_name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_out[count.index].arn]
}

# ---------------------------------------------------
# CloudWatch Alarms: Scale In
# ---------------------------------------------------
resource aws_cloudwatch_metric_alarm scale_in_alarm {
  count               = var.sqs_queue_name != "" ? 1 : 0
  alarm_name          = "${var.name_prefix}-${var.zenv}-${var.service_name}-scale-in-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = var.target_sqs_messages
  alarm_description   = "Scale in if number of visible messages in SQS is below the threshold."
  dimensions = {
    QueueName = var.sqs_queue_name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_in[count.index].arn]
}
