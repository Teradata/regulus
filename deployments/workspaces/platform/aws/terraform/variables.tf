variable "region" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.large"
}

variable "key_name" {
  description = "name of existing ssh key to enable access to workspaces server"
  type = string
  default = null
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "workspaces_name" {
  type = string
  default = "workspaces"
}

variable "workspaces_registry" {
  type = string
  default = "teradata"
}

variable "workspaces_repository" {
  type = string
  default = "workspaces"
}

variable "workspaces_version" {
  type = string
  default = "latest"
}

variable "access_cidrs" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "monitoring_enabled" {
  bool = false
}

variable "http_port" {
  type = number
  default = 3000
}

variable "grpc_port" {
  type = number
  default = 3282
}
