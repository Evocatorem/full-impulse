

**Usage:**
- Perform aws configure before using
- Perform docker login before using
- Add nginx and app to your docker registry and put the full path of them to variables inside MAKEFILE
- Review all variables inside MAKEFILE and reset if needed
- Run ```make```

**Requirements:**
- aws-cli
- terraform
- docker










This Terraform configuration creates:

A VPC with public subnets.
A security groups: first allows HTTP traffic to ALB, second from alb to nginx, third from nginx to app.
An ECS Fargate cluster.
An Aurora PostgreSQL RDS cluster.
IAM roles for ECS tasks.
ECS task definitions for the application and NGINX services.
ECS services for running the tasks.
An Application Load Balancer with a listener that forwards traffic to the NGINX service.
