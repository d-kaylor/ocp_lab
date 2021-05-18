terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

locals {
  master_ips = split(",", var.master_ips)
  infra_ips  = split(",", var.infra_ips)
  node_ips   = split(",", var.node_ips)
}

module "masters" {
  source = "../modules/node/"
  count  = length(local.master_ips)

  ocp_version   = var.ocp_version
  image_path    = var.image_path
  node_type     = "master"
  node_number   = count.index+1
  root_password = var.root_password
  memory        = var.memory
  vcpu          = var.vcpu
  domain        = var.domain
  dns           = var.dns
  ip_address    = local.master_ips[count.index]
  cidr          = var.cidr
  gateway       = var.gateway
}

module "infras" {
  source = "../modules/node/"
  count  = length(local.infra_ips)

  ocp_version   = var.ocp_version
  image_path    = var.image_path
  node_type     = "infra"
  node_number   = count.index+1
  root_password = var.root_password
  memory        = var.memory
  vcpu          = var.vcpu
  domain        = var.domain
  dns           = var.dns
  ip_address    = local.infra_ips[count.index]
  cidr          = var.cidr
  gateway       = var.gateway
}

module "nodes" {
  source = "../modules/node/"
  count  = length(local.node_ips)

  ocp_version   = var.ocp_version
  image_path    = var.image_path
  node_type     = "node"
  node_number   = count.index+1
  root_password = var.root_password
  memory        = var.memory
  vcpu          = var.vcpu
  domain        = var.domain
  dns           = var.dns
  ip_address    = local.node_ips[count.index]
  cidr          = var.cidr
  gateway       = var.gateway
}
