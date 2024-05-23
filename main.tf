variable "esxi_password" {
  description = "ESXi wachtwoord"
  type        = string
  sensitive   = true  
}

provider "vsphere" {
  user     = "I540703@fhict.local"
  password = var.esxi_password
  vsphere_server = "vcenter.netlab.fhict.nl"
   allow_unverified_ssl = true
}


data "vsphere_datacenter" "datacenter" {
  name = "Netlab-DC"
}

data "vsphere_datastore" "datastore" {
  name          = "NIM01-I3-DB"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}



data "vsphere_network" "network" {
  name          = "0123_Internet-DHCP-192.168.123.0_24"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_resource_pool" "resource_pool" {
  name                    = "I540703"
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "test-router"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 1
  memory           = 1024
  guest_id         = "other3xLinux64Guest"
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = 20
  }
}