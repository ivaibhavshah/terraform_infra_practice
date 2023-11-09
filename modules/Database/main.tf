resource "aws_db_subnet_group" "aws_db_subnet_group" {
  name       = "db-subnet-group"
  description = " DB Subnet Group"
  subnet_ids  = var.private_subnet_ids
}
resource "aws_rds_cluster" "db" {
  cluster_identifier      = "${terraform.workspace}-rds-aurora"
  engine                  = "aurora-mysql"
  engine_version          = "8.0"
  availability_zones      = terraform.workspace == "prod" ? ["ap-south-1a","ap-south-1b"] : ["ap-south-1a"]
  database_name           = var.database_name
  master_username         = var.username
  master_password         = var.password
  skip_final_snapshot     = true
  depends_on = [ aws_db_subnet_group.aws_db_subnet_group ]
  
  db_subnet_group_name = aws_db_subnet_group.aws_db_subnet_group.name
}

resource "aws_security_group" "database_security_group" {
  name        = "${terraform.workspace}-sg-rds"
  description = "database security group to allow inbound/outbound from the VPC"
  vpc_id      = var.vpc_id
  ingress {
    description = "mysql/aurora"
    from_port = "3306"
    to_port   = "3306"
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = "${terraform.workspace}-ecs-db-sg"
  }
}
