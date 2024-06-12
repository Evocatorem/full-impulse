# Variables
DOCKER_APP_REPO := evocatorem/impulse-app
DOCKER_NGINX_REPO := evocatorem/impulse-nginx
AWS_REGION := us-west-2
APP_IMAGE_TAG := latest
NGINX_IMAGE_TAG := latest


# Derived variables
APP_IMAGE_URI := $(DOCKER_APP_REPO):$(APP_IMAGE_TAG)
NGINX_IMAGE_URI := $(DOCKER_NGINX_REPO):$(NGINX_IMAGE_TAG)

# Docker build targets
.PHONY: all app-image nginx-image push-app push-nginx create-tfvars terraform-init terraform-apply

all: push-app push-nginx terraform-apply

app-image:
	@echo "Building application Docker image..."
	cd warp && docker build -t $(APP_IMAGE_URI) .

nginx-image:
	@echo "Building nginx Docker image..."
	docker build -t $(NGINX_IMAGE_URI) -f Dockerfile-nginx .

# ECR login and push targets
push-app: app-image
	@echo "Pushing application Docker image to docker registry..."
	docker push $(APP_IMAGE_URI)

push-nginx: nginx-image
	@echo "Pushing nginx Docker image to docker registry..."
	docker push $(NGINX_IMAGE_URI)

# Create terraform.tfvars
create-tfvars:
	@echo "Creating terraform.tfvars file..."
	@cd terraform && echo 'aws_region          = "$(AWS_REGION)"' > terraform.tfvars
	@cd terraform && echo 'health_check_path   = "/"' >> terraform.tfvars
	@cd terraform && echo 'app_port            = 8000' >> terraform.tfvars
	@cd terraform && echo "app_image           = \"$(APP_IMAGE_URI)\"" >> terraform.tfvars
	@cd terraform && echo "nginx_image         = \"$(NGINX_IMAGE_URI)\"" >> terraform.tfvars

# Terraform targets
terraform-init: create-tfvars
	@echo "Initializing Terraform..."
	cd terraform && terraform init

terraform-apply: terraform-init
	@echo "Applying Terraform configuration..."
	cd terraform && terraform apply -auto-approve

# Clean up Docker images
clean:
	@echo "Cleaning up local Docker images..."
	docker rmi $(APP_IMAGE_URI) $(NGINX_IMAGE_URI)
