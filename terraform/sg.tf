resource "aws_security_group" "impulse_lb_security_group" {
  vpc_id        = aws_vpc.impulse_vpc.id
  name          = "allow_http_alb"
  description   = "Allow HTTP inbound traffic and all outbound traffic"
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


resource "aws_security_group" "impulse_app_security_group" {
  vpc_id      = aws_vpc.impulse_vpc.id
  name        = "allow_http_app"
  description = "Allow HTTP inbound traffic for ALB and all outbound traffic"
  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 8000
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.impulse_lb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "impulse_rds_security_group" {
  vpc_id = aws_vpc.impulse_vpc.id
  name        = "allow_psql"
  description = "Allow PSQL inbound traffic and all outbound traffic"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.impulse_app_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}