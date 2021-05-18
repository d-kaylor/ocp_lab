variable "base_name" {
  type    = string
}

variable "source_img" {
  type    = string
  default = null
}

variable "format" {
  type    = string
  default = "qcow2"
}

variable "size" {
  type    = number
  default = null
}
