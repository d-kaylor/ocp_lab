terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

locals {
  extension = var.format == "qcow2" ? "qcow2" : "img"
}

resource "libvirt_volume" "pre-size" {
  name   = join(".", [var.base_name], ["pre"])
  source = var.source_img
  format = var.format
}

resource "libvirt_volume" "volume" {
  name           = join(".", [var.base_name], [local.extension])
  base_volume_id = libvirt_volume.pre-size.id
  size           = var.size
}
