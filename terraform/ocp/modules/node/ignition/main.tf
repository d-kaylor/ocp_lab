terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
    template = {
      source = "hashicorp/template"
    }
    ignition = {
      source = "community-terraform-providers/ignition"
      version = ">=2.0.0"
    }
  }
}

data "ignition_file" "host" {
  mode       = 420
  content {
    content  = var.hostname
  }
  path       = "/etc/hostname"
}

data "template_file" "network2" {
  template = file("${path.module}/ifcfg")

  vars = {
    interface  = var.interface
    ip_address = var.ip_address
    prefix     = var.cidr
    gateway    = var.gateway
    dns        = var.dns
    search     = var.search
  }
}

data "ignition_file" "network2" {
  mode       = 420
  content {
    content  = data.template_file.network2.rendered
  }
  path       = "/etc/sysconfig/network-scripts/ifcfg-${var.interface}"
}

data "ignition_config" "ocp" {
  files = [
    data.ignition_file.host.rendered,
    data.ignition_file.network2.rendered
  ]
  merge {
    source = "http://z620.mk.local:8080/ocp/install/${var.node_type}.ign"
  }
}

resource "libvirt_ignition" "ignition" {
  name    = "ignition-${var.ip_address}.ign"
  content = data.ignition_config.ocp.rendered
}
