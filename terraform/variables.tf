variable "aws_region" {
  description = "The GCP region"
  type        = string
}

variable "health_check_path" {
  description = "Target group healthcheck path"
  type        = string
}

variable "app_port" {
  description = "Port used by application"
  type        = number
}

variable "app_image" {
  description = "Full path to the docker image of the application"
  type        = string
}

variable "nginx_image" {
  description = "Full path to the docker image of the custom-config Nginx"
  type        = string
}


