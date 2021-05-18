terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
    ignition = {
      source = "community-terraform-providers/ignition"
      version = ">=2.0.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

locals {
  bootstrap_ip = var.bootstrap_ip
  master_ips   = split(",", var.master_ips)
  worker_ips   = split(",", var.worker_ips)
}

module "bootstrap" {
  source = "../modules/node/"

  ocp_version   = var.ocp_version
  image_path    = var.image_path
  node_type     = "bootstrap"
  node_number   = 1
  memory        = var.memory
  vcpu          = var.vcpu
  domain        = var.domain
  dns           = var.dns
  interface     = var.interface
  ip_address    = local.bootstrap_ip
  cidr          = var.cidr
  gateway       = var.gateway
}

module "masters" {
  source = "../modules/node/"
  count  = length(local.master_ips)

  ocp_version   = var.ocp_version
  image_path    = var.image_path
  node_type     = "master"
  node_number   = count.index+1
  memory        = var.memory
  vcpu          = var.vcpu
  domain        = var.domain
  dns           = var.dns
  interface     = var.interface
  ip_address    = local.master_ips[count.index]
  cidr          = var.cidr
  gateway       = var.gateway
}

module "workers" {
  source     = "../modules/node/"
#  depends_on = [ "null_resource.wait-for-bootstrap" ]
  count      = length(local.worker_ips)

  ocp_version   = var.ocp_version
  image_path    = var.image_path
  node_type     = "worker"
  node_number   = count.index+1
  memory        = var.memory
  vcpu          = var.vcpu
  domain        = var.domain
  dns           = var.dns
  interface     = var.interface
  ip_address    = local.worker_ips[count.index]
  cidr          = var.cidr
  gateway       = var.gateway
}
