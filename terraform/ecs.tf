

#cluster
resource "aws_ecs_cluster" "main" {
  name = "app1-cluster"
}

#role
resource "aws_iam_role" "ecs_task_execution" {
  name = "app1-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

#policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# task_definitions
resource "aws_ecs_task_definition" "app1-td" {
  family                   = "app1-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "api-server",
      image     = "sudoharish/api-server:latest",
      portMappings = [
        {
          containerPort = 8005,
          hostPort      = 8005,
          protocol      = "tcp"
        }
      ]
    }
  ])
}

#service
resource "aws_ecs_service" "app1-api-service" {
  name            = "app1-api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app1-td.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api-server"
    container_port   = 8005
  }

  depends_on = [aws_lb_listener.http]
}

#sg
resource "aws_security_group" "ecs_tasks_sg" {
  name   = "app1-ecs-tasks-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 8005
    to_port         = 8005
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#TG
resource "aws_lb_target_group" "api" {
  name        = "app1-api-target-group"
  port        = 8005
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path     = "/"
    interval = 30
    timeout  = 5
  }
}

#lb
resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.app1.arn
  load_balancer_arn = aws_lb.app1-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}
