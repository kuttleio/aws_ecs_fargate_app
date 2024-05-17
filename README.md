## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main_container_definition"></a> [main\_container\_definition](#module\_main\_container\_definition) | cloudposse/ecs-container-definition/aws | 0.58.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ecs_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_subscription_filter.lambda_logfilter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb_listener.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_service_discovery_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_acm_certificate.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_containers"></a> [additional\_containers](#input\_additional\_containers) | Additional containers definition | `list` | `[]` | no |
| <a name="input_aws_lb_arn"></a> [aws\_lb\_arn](#input\_aws\_lb\_arn) | n/a | `string` | `""` | no |
| <a name="input_aws_lb_certificate_arn"></a> [aws\_lb\_certificate\_arn](#input\_aws\_lb\_certificate\_arn) | Certificate ARN. Used only if public != true | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ECS Cluster name | `string` | `"fargate"` | no |
| <a name="input_command"></a> [command](#input\_command) | Commands to run on launch | `list(string)` | `null` | no |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | Container vCPU. 256 = 0.25 vCPU \| 1024 = 1.0 vCPU \| 4096 = 4.0 vCPU (max) | `number` | `256` | no |
| <a name="input_container_cpu_high_threshold"></a> [container\_cpu\_high\_threshold](#input\_container\_cpu\_high\_threshold) | n/a | `number` | `30` | no |
| <a name="input_container_cpu_low_threshold"></a> [container\_cpu\_low\_threshold](#input\_container\_cpu\_low\_threshold) | n/a | `number` | `60` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | Container Memory (RAM). 512 = 512 Mb \| 1024 = 1024 Mb = 1.0 Gb \| 8192 = 8192 Mb = 8.0 Gb (max) | `number` | `512` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | n/a | `number` | `1` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `any` | n/a | yes |
| <a name="input_ecr_account_id"></a> [ecr\_account\_id](#input\_ecr\_account\_id) | n/a | `any` | n/a | yes |
| <a name="input_ecr_region"></a> [ecr\_region](#input\_ecr\_region) | n/a | `any` | n/a | yes |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | n/a | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | List of Environment Variables | <pre>list(object({<br>    name  = any<br>    value = any<br>  }))</pre> | `[]` | no |
| <a name="input_external_port"></a> [external\_port](#input\_external\_port) | You do not need to specify it | `number` | `443` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Set 300 if your container needs to build / initialize something on launch | `number` | `null` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health checks path | `string` | `"/health"` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | n/a | `string` | `"nginx"` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | n/a | `string` | `"latest"` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | n/a | `string` | `"FARGATE"` | no |
| <a name="input_logdna_lambda_logs_arn"></a> [logdna\_lambda\_logs\_arn](#input\_logdna\_lambda\_logs\_arn) | n/a | `any` | n/a | yes |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | n/a | `number` | `1` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | n/a | `number` | `1` | no |
| <a name="input_mount_points"></a> [mount\_points](#input\_mount\_points) | Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume` | <pre>list(object({<br>    containerPath = string<br>    sourceVolume  = string<br>    readOnly      = bool<br>  }))</pre> | `[]` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_public"></a> [public](#input\_public) | Set as true to use with public load balancer | `bool` | `false` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Amount of days to store service logs | `number` | `7` | no |
| <a name="input_run_on_spots"></a> [run\_on\_spots](#input\_run\_on\_spots) | Set true to run 100% on FARGATE\_SPOT | `bool` | `false` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of Secrets | <pre>list(object({<br>    name      = string<br>    valueFrom = string<br>  }))</pre> | `[]` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | n/a | `any` | n/a | yes |
| <a name="input_service_discovery_id"></a> [service\_discovery\_id](#input\_service\_discovery\_id) | n/a | `string` | `""` | no |
| <a name="input_service_image"></a> [service\_image](#input\_service\_image) | Full ECR Url. Example: 000000000000.dkr.ecr.us-west-2.amazonaws.com/repo\_name:image\_version | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | ECS Service name. Better to use with prefix | `string` | `"fargate"` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Container port. It is fine to leave the default value | `number` | `8080` | no |
| <a name="input_standard_tags"></a> [standard\_tags](#input\_standard\_tags) | Tags | `map(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | `any` | n/a | yes |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | Task vCPU. 256 = 0.25 vCPU \| 1024 = 1.0 vCPU \| 4096 = 4.0 vCPU (max) | `number` | `256` | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | Task Memory (RAM). 512 = 512 Mb \| 1024 = 1024 Mb = 1.0 Gb \| 8192 = 8192 Mb = 8.0 Gb (max) | `number` | `512` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | Task Role ARN | `string` | `null` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Task volume definitions as list of configuration objects | <pre>list(object({<br>    name = string<br>    efs_volume_configuration = list(object({<br>      file_system_id = string<br>      root_directory = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |
| <a name="input_zenv"></a> [zenv](#input\_zenv) | n/a | `string` | `"fargate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | n/a |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | n/a |

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main_container_definition"></a> [main\_container\_definition](#module\_main\_container\_definition) | cloudposse/ecs-container-definition/aws | 0.61.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ecs_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_subscription_filter.lambda_logfilter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb_listener.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_service_discovery_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_acm_certificate.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_containers"></a> [additional\_containers](#input\_additional\_containers) | Additional containers definition | `list(string)` | `[]` | no |
| <a name="input_aws_lb_arn"></a> [aws\_lb\_arn](#input\_aws\_lb\_arn) | Load Balancer ARN (if $public = true) | `string` | `""` | no |
| <a name="input_aws_lb_certificate_arn"></a> [aws\_lb\_certificate\_arn](#input\_aws\_lb\_certificate\_arn) | Certificate ARN (if $public != true) | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ECS Cluster name | `string` | `"fargate"` | no |
| <a name="input_command"></a> [command](#input\_command) | Commands to run on launch | `list(string)` | `null` | no |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | Container vCPU. 256 = 0.25 vCPU \| 1024 = 1.0 vCPU \| 4096 = 4.0 vCPU (max) | `number` | `256` | no |
| <a name="input_container_cpu_high_threshold"></a> [container\_cpu\_high\_threshold](#input\_container\_cpu\_high\_threshold) | Autoscaling: High CPU Threshold | `number` | `30` | no |
| <a name="input_container_cpu_low_threshold"></a> [container\_cpu\_low\_threshold](#input\_container\_cpu\_low\_threshold) | Autoscaling: Low CPU Threshold | `number` | `60` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | Container Memory (RAM). 512 = 512 Mb \| 1024 = 1024 Mb = 1.0 Gb \| 8192 = 8192 Mb = 8.0 Gb (max) | `number` | `512` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired task count | `number` | `1` | no |
| <a name="input_disk_size_in_gib"></a> [disk\_size\_in\_gib](#input\_disk\_size\_in\_gib) | ECS Task ephemeral storage (in Gigs) | `number` | `21` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `any` | n/a | yes |
| <a name="input_ecr_account_id"></a> [ecr\_account\_id](#input\_ecr\_account\_id) | n/a | `any` | n/a | yes |
| <a name="input_ecr_region"></a> [ecr\_region](#input\_ecr\_region) | n/a | `any` | n/a | yes |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | Just entrypoint | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | List of Environment Variables | <pre>list(object({<br>    name  = any<br>    value = any<br>  }))</pre> | `[]` | no |
| <a name="input_external_port"></a> [external\_port](#input\_external\_port) | No need to set it up. Used for public services (if $public = true) | `number` | `443` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Set 300 if your container needs to be initialized on launch | `number` | `null` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health checks path. Best to use the default one | `string` | `"/health"` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Image name | `string` | `"nginx"` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | Image version | `string` | `"latest"` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | Launch type. Just leave as FARGATE | `string` | `"FARGATE"` | no |
| <a name="input_logs_destination_arn"></a> [logs\_destination\_arn](#input\_logs\_destination\_arn) | ARN where you want to push the logs | `string` | `""` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Autoscaling: Max capacity | `number` | `1` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Autoscaling: Min capacity | `number` | `1` | no |
| <a name="input_mount_points"></a> [mount\_points](#input\_mount\_points) | Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume` | <pre>list(object({<br>    containerPath = string<br>    sourceVolume  = string<br>    readOnly      = bool<br>  }))</pre> | `[]` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_public"></a> [public](#input\_public) | Set as true to use with public load balancer | `bool` | `false` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | How many days you want to store your logs. Mind costs. | `number` | `7` | no |
| <a name="input_run_on_spots"></a> [run\_on\_spots](#input\_run\_on\_spots) | Set true to run 100% on FARGATE\_SPOT | `bool` | `true` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of Secrets | <pre>list(object({<br>    name      = string<br>    valueFrom = string<br>  }))</pre> | `[]` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | n/a | `any` | n/a | yes |
| <a name="input_service_discovery_id"></a> [service\_discovery\_id](#input\_service\_discovery\_id) | Service discovery ID | `string` | `""` | no |
| <a name="input_service_image"></a> [service\_image](#input\_service\_image) | Full ECR Url. Example: 000000000000.dkr.ecr.us-west-2.amazonaws.com/repo\_name:image\_version | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | ECS Service name. Use with prefix like: $account-$region-$name | `string` | `"fargate"` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Container port. OK to use the default value | `number` | `8080` | no |
| <a name="input_standard_tags"></a> [standard\_tags](#input\_standard\_tags) | Tags | `map(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | `any` | n/a | yes |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | Task vCPU. 256 = 0.25 vCPU \| 1024 = 1.0 vCPU \| 4096 = 4.0 vCPU (max) | `number` | `256` | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | Task Memory (RAM). 512 = 512 Mb \| 1024 = 1024 Mb = 1.0 Gb \| 8192 = 8192 Mb = 8.0 Gb (max) | `number` | `512` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | Task Role ARN | `string` | `null` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Task volume definitions as list of configuration objects | <pre>list(object({<br>    name = string<br>    efs_volume_configuration = list(object({<br>      file_system_id = string<br>      root_directory = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |
| <a name="input_zenv"></a> [zenv](#input\_zenv) | Environment name (stack) | `string` | `"fargate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Service name |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | Service port |
<!-- END_TF_DOCS -->