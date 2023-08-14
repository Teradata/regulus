variable "region" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.large"
}

variable "key_name" {
  description = "name of existing ssh key to enable access to jupyter server"
  type        = string
  default     = null
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

variable "access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "egress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "access_security_groups" {
  type    = list(string)
  default = []
}

variable "monitoring_enabled" {
  type = bool 
  default = false
}

variable "http_port" {
  type    = number
  default = 8888
}

variable "user_tags" {
  type    = map(string)
  default = {}
}
