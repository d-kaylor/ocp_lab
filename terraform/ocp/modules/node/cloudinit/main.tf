terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")

  vars = {
    hostname      = var.hostname
    root_password = var.root_password
  }
}

data "template_file" "network" {
  template = file("${path.module}/network.cfg")

  vars = {
    ip_address = "${var.ip_address}/${var.cidr}"
    gateway    = var.gateway
    dns        = var.dns
    search     = var.search
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name           = "cloudinit-${var.ip_address}.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network.rendered
}
