resource "aws_db_instance" "impulse_rds_instance" {
  identifier             = "impulse-postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.10"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.impulse_rds_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.impulse_db_subnet_group.name
  username               = "postgres"
  password               = "postgres_password"
}