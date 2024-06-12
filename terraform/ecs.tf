resource "aws_ecs_cluster" "impulse_ecs_cluster" {
  name = "impulse-ecs-cluster"
}

resource "aws_ecs_task_definition" "impulse_app_task" {
  family                   = "impulse-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "2048"

  execution_role_arn = aws_iam_role.impulse_ecs_task_execution.arn
  task_role_arn      = aws_iam_role.impulse_ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "warp-demo-wsgi"
      image     = var.app_image
      essential = true
      cpu       = 384
      memory    = 1792

      environment = [
        { name = "WARP_DATABASE", value = "postgresql://postgres:postgres_password@${aws_db_instance.impulse_rds_instance.endpoint}:5432/postgres" },
        { name = "WARP_SECRET_KEY", value = "mysecretkey" },
        { name = "WARP_DATABASE_INIT_SCRIPT", value = "[\"sql/schema.sql\",\"sql/sample_data.sql\"]" },
        { name = "WARP_LANGUAGE_FILE", value = "i18n/en.js" },
      ]

      portMappings = [
        {
          containerPort = var.app_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/impulse"
          "awslogs-region"        = "${var.aws_region}"
          "awslogs-stream-prefix" = "App"
        }
      }
    },
    {
      name      = "nginx"
      image     = var.nginx_image
      essential = true
      cpu       = 128
      memory    = 256
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      dependsOn = [
        {
          containerName = "warp-demo-wsgi"
          condition     = "START"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/impulse"
          "awslogs-region"        = "${var.aws_region}"
          "awslogs-stream-prefix" = "nginx"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "impulse_app_service" {
  name                    = "impulse-app-service"
  cluster                 = aws_ecs_cluster.impulse_ecs_cluster.id
  task_definition         = aws_ecs_task_definition.impulse_app_task.arn
  desired_count           = 1
  enable_ecs_managed_tags = true
  launch_type             = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.impulse_subnet[*].id
    security_groups  = [aws_security_group.impulse_app_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.impulse_app_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }
}
