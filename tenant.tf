resource "aci_tenant" "tenant" {
  name        = "aci_tenant_name"
  description = "This tenant is created by terraform"
}

resource "aci_vrf" "test-vrf" {
  tenant_dn	= aci_tenant.tenant.id
  name 		= "test-vrf"
}

resource "aci_bridge_domain" "dev_bd" {
  tenant_dn	= aci_tenant.tenant.id
  name		= "dev_bd"
}


resource "aci_subnet" "dev_subnet" {
  parent_dn 	= aci_bridge_domain.dev_bd.id
  ip 			= "10.10.0.1/16"
}

resource "aci_l3_outside" "internet" {
  tenant_dn = aci_tenant.tenant.id
  name      = "internet"
}

resource "aci_external_network_instance_profile" "dev_ext_net_prof" {
  l3_outside_dn = aci_l3_outside.internet.id
  name          = "ext_net_profile"
}

resource "aci_l3_ext_subnet" "ext_subnet" {
  external_network_instance_profile_dn = aci_external_network_instance_profile.dev_ext_net_prof.id
  ip          = "10.0.3.28/27"
}
