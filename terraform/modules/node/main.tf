terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

locals {
  node_name  = "${var.node_type}-${var.node_number}.${var.domain}"
}

module "os_volume" {
  source = "./volume"

  base_name  = local.node_name
  source_img = var.image_path
  size       = 21474836480  
}

module "cloudinit" {
  source = "./cloudinit"
  count  = var.ocp_version == 3 ? 1 : 0

  root_password = var.root_password
  hostname      = local.node_name
  ip_address    = var.ip_address
  cidr          = var.cidr
  gateway       = var.gateway
  dns           = var.dns
  search        = var.domain
}

module "ignition" {
  source = "./ignition"
  count  = var.ocp_version == 4 ? 1 : 0

  node_type  = var.node_type
  hostname   = local.node_name
  interface  = var.interface
  ip_address = var.ip_address
  cidr       = var.cidr
  gateway    = var.gateway
  dns        = var.dns
  search     = var.domain
}

resource "libvirt_domain" "node" {
  name   = local.node_name
  memory = var.memory
  vcpu   = var.vcpu

  cloudinit = var.ocp_version == 3 ? module.cloudinit[0].libvirt_cloudinit_id : null

  coreos_ignition = var.ocp_version == 4 ? module.ignition[0].libvirt_ignition_id : null

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = module.os_volume.libvirt_volume_id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type           = "vnc"
    listen_type    = "address"
    listen_address = "0.0.0.0"
    autoport       = true
  }
}
