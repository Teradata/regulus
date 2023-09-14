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

variable "workspaces_name" {
  type    = string
  default = "workspaces"
}

variable "workspaces_registry" {
  type    = string
  default = "teradata"
}

variable "workspaces_repository" {
  type    = string
  default = "regulus-workspaces"
}

variable "workspaces_version" {
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
  default = 3000
}

variable "grpc_port" {
  type    = number
  default = 3282
}

variable "disk_type" {
  type    = string
  default = "Standard_LRS"
}

variable "disk_size" {
  type    = number
  default = 30
}

variable "role_definition_name" {
  type    = string
  default = null
}