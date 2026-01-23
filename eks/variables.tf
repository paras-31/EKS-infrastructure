variable "cluster_name" {
  type = string
  description = "pass the cluster name"
  default = "eksdemo"
}

variable "role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}