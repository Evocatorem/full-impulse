resource "aws_iam_role" "impulse_ecs_task_execution" {
  name               = "impulse-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.impulse_ecs_task_execution_assume_role_policy.json
}

data "aws_iam_policy_document" "impulse_ecs_task_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "impulse_ecs_task_execution_policy" {
  role       = aws_iam_role.impulse_ecs_task_execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}