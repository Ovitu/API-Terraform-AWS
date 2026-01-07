# 1. PROVIDER
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 2. REDE (VPC e SUBNETS)
resource "aws_vpc" "desafio_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true # Essencial para o RDS
  enable_dns_support   = true
  tags                 = { Name = "desafioo-vpc" }
}

resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.desafio_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet-fargate" }
}

resource "aws_subnet" "private_sub" {
  vpc_id            = aws_vpc.desafio_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "private-subnet-rds" }
}

# 3. INTERNET ACCESS
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.desafio_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.desafio_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.public_rt.id
}

# 4. SECURITY GROUPS (AJUSTADOS)
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.desafio_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "fargate_sg" {
  name   = "fargate-sg"
  vpc_id = aws_vpc.desafio_vpc.id
  ingress {
    from_port       = 3000 # Ajustado para sua API
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_security" {
  name   = "rds-sg"
  vpc_id = aws_vpc.desafio_vpc.id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.fargate_sg.id] # Segurança Máxima: Só Fargate entra
  }
}

# 5. BANCO DE DADOS RDS
resource "aws_db_subnet_group" "rds_sg_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_sub.id, aws_subnet.public_sub.id]
}

resource "aws_db_instance" "postgres_db" {
  allocated_storage      = 20
  db_name                = "meubanco"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  username               = "postgres"
  password               = "SenhaSegura123"
  db_subnet_group_name   = aws_db_subnet_group.rds_sg_group.name
  vpc_security_group_ids = [aws_security_group.rds_security.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
}

# 6. LOAD BALANCER (ALB)
resource "aws_lb" "meu_alb" {
  name               = "alb-fargate-desafio"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_sub.id, aws_subnet.private_sub.id]
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-target-group"
  port        = 3000 # Porta da sua API
  protocol    = "HTTP"
  vpc_id      = aws_vpc.desafio_vpc.id
  target_type = "ip"
  health_check { path = "/" } # Testa se o '/' responde 200 OK
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.meu_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

# 7. ECS (CLUSTER, TASK E SERVICE)
resource "aws_ecr_repository" "meu_app_repo" {
  name = "repositorio-desafio"
}

resource "aws_ecs_cluster" "meu_cluster" {
  name = "cluster-fargate-desafio"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-execution-role-new"
  assume_role_policy = jsonencode({
    Version = "2012-10-17", Statement = [{
      Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_att" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name  = "minha-api"
    image = "${aws_ecr_repository.meu_app_repo.repository_url}:latest"
    portMappings = [{ containerPort = 3000, hostPort = 3000 }]
    
    # VARIÁVEIS CONECTANDO COM SEU INDEX.JS
    environment = [
      { name = "DB_HOST",     value = aws_db_instance.postgres_db.address },
      { name = "DB_NAME",     value = "meubanco" },
      { name = "DB_USER",     value = "postgres" },
      { name = "DB_PASSWORD", value = "SenhaSegura123" },
      { name = "DB_PORT",     value = "5432" },
      { name = "API_PORT",    value = "3000" }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group" = "/ecs/minha-api", "awslogs-region" = "us-east-1", "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_cloudwatch_log_group" "ecs_logs" { name = "/ecs/minha-api" }

resource "aws_ecs_service" "app_service" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.meu_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.public_sub.id]
    security_groups  = [aws_security_group.fargate_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "minha-api"
    container_port   = 3000
  }
}

