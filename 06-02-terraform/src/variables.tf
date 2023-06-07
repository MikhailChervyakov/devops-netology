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
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_image"{
   type = string
   default = "ubuntu-2004-lts"
   description = "image os"
}

variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
  description = "platform name"
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v1"
  description = "platform id"
}

variable "environment" {
  type        = string
  default     = "development"
  description = "environment name"
}

variable "vm_web_resources"{
  type = map
  default ={
      core         =  2
      memory        = 1
      core_fraction = 5
  }

}

variable "vm_metadata" {
  type = map(object({
    serial-port-enable = number
    ssh-keys           = string
  }))
  default = {
    "data" = {
      serial-port-enable = 1
      ssh-keys           = "ubuntu:key"
    }
  }
}

# variable "vm_web_core" {
#   type = number
#   default = 2
#   description = "number of cpu cores"
# }


# variable "vm_web_memory" {
#   type = number
#   default = 1
#   description = "number of memory"
# }


# variable "vm_web_fraction" {
#   type = number
#   default = 5
#   description = "number of fraction"

# }
