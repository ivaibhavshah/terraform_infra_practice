resource "aws_ecr_repository" "ecr" {
  name = var.ecr_name
  image_tag_mutability = var.image_mutability 
  encryption_configuration {
    encryption_type = "KMS"
  }
  image_scanning_configuration {
    scan_on_push = true
  }
} 
resource "aws_ecs_cluster" "my_cluster" {
  name = var.ecs_cluster_name
  
  
}
resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.my_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
/* Task definition */
resource "aws_ecs_task_definition" "my_task" {
  family                   = "${terraform.workspace}-ECS-Container"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  /* execution_role_arn        = aws_iam_role.ecs_execution_role.arn */
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  
  memory = 512 /*in mib*/
  cpu = 256
  container_definitions = jsonencode([
    {
      essential = true
      name  = "${terraform.workspace}-ECS-Container"
      image = "${aws_ecr_repository.ecr.repository_url}:latest"
      force_new_deployment = true
      # image = "nginx:latest"
      execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
      task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
      memory : var.container_memory
      cpu : var.container_cpu
          
    }
  ])
  lifecycle {
    ignore_changes = [ container_definitions ]
  }
}
data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.my_task.family
}

resource "aws_ecs_service" "my_service" {  
  name                 = var.service_name
  cluster              = aws_ecs_cluster.my_cluster.id
  task_definition      = "${aws_ecs_task_definition.my_task.family}"
  # revision = latest
  launch_type          = "FARGATE"
  /* depends_on = [ data.aws_ecs_task_definition.main] */
  desired_count        = var.desired_count
  force_new_deployment = true
  deployment_controller {
    type = "ECS"
    }
  depends_on = [ aws_lb_target_group.ecs_tg]
  network_configuration {
    subnets = var.private_subnet_id
    security_groups = [aws_security_group.my_security_group.id]
    assign_public_ip = false
     
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg[1].arn
    container_name = aws_ecs_task_definition.my_task.family
    container_port = var.container_port
  }
  lifecycle {
    ignore_changes = [desired_count,
          task_definition,
          load_balancer,
          network_configuration
    ]

  }
}

/* ALB */
resource "aws_security_group" "my_security_group" {
  name        = "${terraform.workspace}-sg"
  description = "security group to allow inbound/outbound from the VPC " 
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Environment = "${terraform.workspace}-ecs-sg"
  }
}
resource "aws_lb" "ecs_alb" {
 name               = "${terraform.workspace}-${var.project_name}-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.my_security_group.id]
 subnets            = [var.public_subnet_id[0],var.public_subnet_id[1]]
 enable_http2 = true
 tags = {
   Name = "${terraform.workspace}-ecs-alb"
 }
  }
  locals {
  target_groups = [
    "green",
    "blue",
  ]
}
resource "aws_lb_target_group" "ecs_tg" {
  count = length(local.target_groups)

  name        = "tg-${terraform.workspace}-${var.project_name}-${element(local.target_groups, count.index)}"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  depends_on = [ aws_lb.ecs_alb ]
  
 health_check {
  path = "/"
  healthy_threshold   = "3"
  interval            = "300"
  protocol            = "HTTP"
  matcher             = "200"
  timeout             = "3"
  unhealthy_threshold = "2"
  }
  tags = {
  Name = "ecs-target-group-${terraform.workspace}-${var.project_name}"
  }
} 

resource "aws_lb_listener" "ecs_alb_listener1" {
 load_balancer_arn = aws_lb.ecs_alb.id
 port              = var.load_balancer_listener_port
 protocol          = "HTTP"
 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg[1].id
 }
}