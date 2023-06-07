###ssh vars
variable "vm_db_image"{
   type = string
   default = "ubuntu-2004-lts"
   description = "image os"
}

variable "vm_db_name" {
  type = string
  default = "netology-develop-platform-db"
  description = "platform name"
}

variable "vm_db_platform_id" {
  type = string
  default = "standard-v1"
  description = "platform id"
}

variable "vm_db_resources"{
  type = map
  default ={
      core          = 2
      memory        = 2
      core_fraction = 20
  }

}

# variable "vm_db_metadata"{
#   type = map(string)
#   default ={
#       serial-port-enable = 1
#       ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
      
#   }

# }


# variable "vm_db_core" {
#   type = number
#   default = 2
#   description = "number of cpu cores"
# }


# variable "vm_db_memory" {
#   type = number
#   default = 2
#   description = "number of memory"
# }


# variable "vm_db_fraction" {
#   type = number
#   default = 20
#   description = "number of fraction"

# }
