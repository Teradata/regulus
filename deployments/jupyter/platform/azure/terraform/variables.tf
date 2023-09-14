variable "region" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "Standard_B2s"
}

variable "key_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "jupyter_name" {
  type    = string
  default = "jupyter"
}

variable "jupyter_registry" {
  type    = string
  default = "teradata"
}

variable "jupyter_repository" {
  type    = string
  default = "regulus-jupyter"
}

variable "jupyter_version" {
  type    = string
  default = "latest"
}

variable "ssh_enabled" {
  type    = bool
  default = false
}

variable "access_cidrs" {
  type = list(string)
}

variable "egress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "http_port" {
  type    = number
  default = 8888
}

variable "disk_type" {
  type    = string
  default = "Standard_LRS"
}

variable "disk_size" {
  type    = number
  default = 30
}
