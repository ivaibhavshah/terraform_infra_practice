
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.project_name}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "${var.project_name}-iam-role"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy_rds_attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy_ecr_attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

