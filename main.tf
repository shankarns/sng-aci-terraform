variable aci_username {
  default = ""
}

variable aci_password {
  default = ""
}

variable aci_url {
  default = ""
}


provider "aci" {
    # cisco-aci user name
    username = var.aci_username
    # cisco-aci password
    password = var.aci_password
    # cisco-aci url
    url      = var.aci_url
    insecure = true
}


