###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBBLEhtVsMJxJ8U31+3drLt0AYPdDc61ogrPpXibHus34Otf1fouaVHvDrMjH4jGK/HkSkMZOnok08RxrKlEV+YN+96iw8MXqqLtpqrLb7zD6syQoQsbZ6wYIaNk1VkW2G6JuiT9kLLKX+VSQSQQznMoNnTfQKEtsxhlZ6XgR4i0kzcXgiJmZigj+c6yfWKezMjtEbW3l2vhKcH/0SYXbNo1jWHrbcmNJIcj5/xCq0JnxSeMQPDg2eFK2mOX+AzS2QByhLAqgX4dg0s3D/QXQ8mL4xE66u+h0lmziT4NU+o/oBF89WAxftHC5ffDtMVx0aLR2G5GKPo7ZoCN+Hxsf/F3D+AHdF9hQtRKI6isKJuWf+pHoqKz/1S3O+HHZ4h1dimCa9pf7sBXNKayKT+7eZs0Fj0npEjqjyz7OiFEUNaTuq9/GFvtKXI/M/HaY6oZKadGhHt5VCG5ubIcf4tUv7h2d64FRgHin5LK9onrngwpuGOaAGKQ/lyxIA4ENAQOM= mike@mike-VirtualBox"
}