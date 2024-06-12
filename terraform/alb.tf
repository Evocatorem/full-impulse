
resource "aws_lb" "impulse_app_lb" {
  name               = "impulse-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.impulse_lb_security_group.id]
  subnets            = aws_subnet.impulse_subnet[*].id
}

resource "aws_lb_target_group" "impulse_app_tg" {
  name        = "impulse-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.impulse_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "impulse_app_listener" {
  load_balancer_arn = aws_lb.impulse_app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.impulse_app_tg.arn
  }
}
