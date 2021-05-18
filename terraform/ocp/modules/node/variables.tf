variable ocp_version {
  type = number
}

variable image_path {
  type = string
}

variable node_type {
  type = string
}

variable node_number {
  type = string
}

# Default set to make this var optinal. RHCOS will not have a root password.
variable "root_password" {
  type    = string
  default = "&@mihDBWp!D#3D"
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
  type    = string
  default = "eth0"
}

variable ip_address {
  type = string
}

variable "cidr" {
  type = number
}

variable "gateway" {
  type = string
}
