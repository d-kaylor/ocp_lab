variable "ocp_version" {
  type = number
}

variable "image_path" {
  type = string
}

variable "memory" {
  type = string
}

variable "vcpu" {
  type = number
}

variable "domain" {
  type = string
}

variable "dns" {
  type = string
}

variable "interface" {
  type = string
}

variable "bootstrap_ip" {
  type = string
}

variable "master_ips" {
  type = string
}

variable "worker_ips" {
  type = string
}

variable "cidr" {
  type = number
}

variable "gateway" {
  type = string
}
