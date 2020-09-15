resource "aci_application_profile" "test-app" {
  tenant_dn   = aci_tenant.test-tenant.id
  name        = "test-app"
  description = "This app profile is created by terraform"
}

resource "aci_application_epg" "WEB_EPG" {
  application_profile_dn = aci_application_profile.test-app.id
  name			 = "WEB_EPG"
}


resource "aci_application_epg" "APP_EPG" {
  application_profile_dn = aci_application_profile.test-app.id
  name			 = "APP_EPG"
}

resource "aci_application_epg" "DB_EPG" {
  application_profile_dn = aci_application_profile.test-app.id
  name			 = "DB_EPG"
}



resource "aci_epg_to_domain" "web" {
  application_epg_dn	= aci_application_epg.WEB_EPG.id
  tdn			= "uni/vmmp-VMware/dom-MIA-VDS"
}


resource "aci_epg_to_domain" "app" {
  application_epg_dn	= aci_application_epg.APP_EPG.id
  tdn			= "uni/vmmp-VMware/dom-MIA-VDS"
}

resource "aci_epg_to_domain" "db" {
  application_epg_dn	= aci_application_epg.DB_EPG.id
  tdn			= "uni/vmmp-VMware/dom-MIA-VDS"
}