
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}



//we concatenate the tenant, app profile and epg to get the portgroup name

data "vsphere_network" "network_web" {
  name          = "${aci_tenant.test-tenant.name}|${aci_application_profile.test-app.name}|${aci_application_epg.WEB_EPG.name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_app" {
  name          = "${aci_tenant.test-tenant.name}|${aci_application_profile.test-app.name}|${aci_application_epg.APP_EPG.name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_db" {
  name          = "${aci_tenant.test-tenant.name}|${aci_application_profile.test-app.name}|${aci_application_epg.DB_EPG.name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "vsphere_virtual_machine" "vm_web" {
  name             = "terraform_web"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vsphere_vm_cpu #2
  memory   = var.vsphere_vm_memory #1024
  guest_id = var.vsphere_vm_guest #"other3xLinux64Guest"

  network_interface {
    network_id = data.vsphere_network.network_web.id
  }

  disk {
    label = "disk0"
    size  = var.vsphere_vm_disksize #20
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.linked_clone
    timeout       = var.timeout

  }


}

resource "vsphere_virtual_machine" "vm_app" {
  name             = "terraform_app"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vsphere_vm_cpu #2
  memory   = var.vsphere_vm_memory #1024
  guest_id = var.vsphere_vm_guest #"other3xLinux64Guest"

  network_interface {
    network_id = data.vsphere_network.network_app.id
  }

  disk {
    label = "disk0"
    size  = var.vsphere_vm_disksize #20
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.linked_clone
    timeout       = var.timeout

  }


}

resource "vsphere_virtual_machine" "vm_db" {
  name             = "terraform_db"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vsphere_vm_cpu #2
  memory   = var.vsphere_vm_memory #1024
  guest_id = var.vsphere_vm_guest #"other3xLinux64Guest"

  network_interface {
    network_id = data.vsphere_network.network_db.id
  }

  disk {
    label = "disk0"
    size  = var.vsphere_vm_disksize #20
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.linked_clone
    timeout       = var.timeout

  }


}



/*
#No more VM module because they want to customize, and I don't want that
module "vm" {
  source  = "Terraform-VMWare-Modules/vm/vsphere"
  version = "2.1.0"
  vmtemp        = var.vsphere_vm_template
  instances     = 1
  vmname        = var.vsphere_vm_name
  vmrp          = var.vsphere_resource_pool
  network = {
    "${var.vsphere_vm_portgroup}"  = ["", ""] # To use DHCP create Empty list ["",""]
  }
  dc        = var.vsphere_datacenter
  datastore = var.vsphere_datastore
}
*/