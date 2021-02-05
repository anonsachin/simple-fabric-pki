terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "myroot"
}

locals {
  engine     = "pki"
  ca_name    = "${var.org_name}CA"
  tlsca_name = "${var.org_name}TLSCA"
  key_type   = "ec"
}

resource "vault_mount" "pki_engine" {
  path = local.ca_name
  type = local.engine
}

resource "vault_pki_secret_backend_root_cert" "ca" {
  backend      = vault_mount.pki_engine.id
  common_name  = local.ca_name
  type         = var.ca_type
  organization = var.org_name
  ttl          = "87600h"
  key_type     = local.key_type
  key_bits     = var.key_bits
}

resource "vault_pki_secret_backend_role" "fabric-peer" {
  backend                            = vault_mount.pki_engine.id
  name                               = "peer"
  generate_lease                     = true
  allow_localhost                    = true
  allow_subdomains                   = true
  allowed_domains                    = var.base_domain
  server_flag                        = false
  client_flag                        = false
  key_usage                          = ["DigitalSignature"]
  key_type                           = local.key_type
  key_bits                           = var.key_bits
  ou                                 = ["peer"]
  organization                       = [var.org_name]
  basic_constraints_valid_for_non_ca = true
}

resource "vault_pki_secret_backend_role" "fabric-admin" {
  backend                            = vault_mount.pki_engine.id
  name                               = "admin"
  generate_lease                     = true
  allow_localhost                    = true
  allow_subdomains                   = true
  allowed_domains                    = var.base_domain
  server_flag                        = false
  client_flag                        = false
  key_usage                          = ["DigitalSignature"]
  key_type                           = local.key_type
  key_bits                           = var.key_bits
  ou                                 = ["admin"]
  organization                       = [var.org_name]
  basic_constraints_valid_for_non_ca = true
}

resource "vault_pki_secret_backend_role" "fabric-client" {
  backend                            = vault_mount.pki_engine.id
  name                               = "client"
  generate_lease                     = true
  allow_localhost                    = true
  allow_subdomains                   = true
  allowed_domains                    = var.base_domain
  server_flag                        = false
  client_flag                        = false
  key_usage                          = ["DigitalSignature"]
  key_type                           = local.key_type
  key_bits                           = var.key_bits
  ou                                 = ["client"]
  organization                       = [var.org_name]
  basic_constraints_valid_for_non_ca = true
}

resource "vault_mount" "tls_pki_engine" {
  path = local.tlsca_name
  type = local.engine
}

resource "vault_pki_secret_backend_root_cert" "tls_ca" {
  backend      = vault_mount.tls_pki_engine.id
  common_name  = local.ca_name
  type         = var.ca_type
  organization = var.org_name
  ttl          = "87600h"
  key_type     = local.key_type
  key_bits     = var.key_bits
}

resource "vault_pki_secret_backend_role" "fabric-peer-tls" {
  backend                            = vault_mount.tls_pki_engine.id
  name                               = "peer"
  generate_lease                     = true
  allow_localhost                    = true
  allow_subdomains                   = true
  allowed_domains                    = var.base_domain
  server_flag                        = true
  client_flag                        = true
  key_usage                          = ["DigitalSignature", "KeyAgreement", "KeyEncipherment"]
  key_type                           = local.key_type
  key_bits                           = var.key_bits
  ou                                 = ["peer"]
  organization                       = [var.org_name]
  basic_constraints_valid_for_non_ca = true
}

resource "vault_pki_secret_backend_role" "fabric-admin-tls" {
  backend                            = vault_mount.tls_pki_engine.id
  name                               = "admin"
  generate_lease                     = true
  allow_localhost                    = true
  allow_subdomains                   = true
  allowed_domains                    = var.base_domain
  server_flag                        = true
  client_flag                        = true
  key_usage                          = ["DigitalSignature", "KeyAgreement", "KeyEncipherment"]
  key_type                           = local.key_type
  key_bits                           = var.key_bits
  ou                                 = ["admin"]
  organization                       = [var.org_name]
  basic_constraints_valid_for_non_ca = true
}

resource "vault_pki_secret_backend_role" "fabric-client-tls" {
  backend                            = vault_mount.tls_pki_engine.id
  name                               = "client"
  generate_lease                     = true
  allow_localhost                    = true
  allow_subdomains                   = true
  allowed_domains                    = var.base_domain
  server_flag                        = true
  client_flag                        = true
  key_usage                          = ["DigitalSignature", "KeyAgreement", "KeyEncipherment"]
  key_type                           = local.key_type
  key_bits                           = var.key_bits
  ou                                 = ["client"]
  organization                       = [var.org_name]
  basic_constraints_valid_for_non_ca = true
}