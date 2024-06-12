This Terraform configuration creates:

A VPC with public subnets.
A security groups: first allows HTTP traffic to ALB, second from alb to nginx, third from nginx to app.
An ECS Fargate cluster.
An Aurora PostgreSQL RDS cluster.
IAM roles for ECS tasks.
ECS task definitions for the application and NGINX services.
ECS services for running the tasks.
An Application Load Balancer with a listener that forwards traffic to the NGINX service.


**Usage:**
- aws configure
- terraform init
- terraform validate
- terraform plan
- terraform apply

**Requirements:**
- aws-cli
- terraform