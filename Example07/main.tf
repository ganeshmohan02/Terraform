# Provider Declaration
terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}
# Provider configuration.
provider "aci" {
    username = "admin"
    password = "!@######"
    url      = "https://172.X.X.X/"
    insecure = true
  }
#Tenant
resource "aci_tenant" "tenantLocalName" {
    description = "cloudGuru_Terraform"
  name        = var.tenant_name
  }
#VRF
resource "aci_vrf" "vrf1LocalName" {
    tenant_dn = aci_tenant.tenantLocalName.id
    name        = var.vrf_name
  }
#Create Multiple BD's
resource "aci_bridge_domain" "bd2LocalName" {
  for_each = var.BD_VAR
  name = each.key
  description      = each.value.description
  arp_flood        = each.value.arp_flood
  unicast_route    = each.value.unicast_route
  tenant_dn = aci_tenant.tenantLocalName.id
  relation_fv_rs_ctx = aci_vrf.vrf1LocalName.id
}
#Create More subnets
resource "aci_subnet" "subnetLocalName" {
  for_each = var.BD_VAR
  parent_dn = aci_bridge_domain.bd2LocalName[each.key].id
  ip = each.value.subnet
  scope = ["public","shared"]
}
#Create Application profile
resource "aci_application_profile" "apLocalName" {
  name = "3tier_APP"
  tenant_dn = aci_tenant.tenantLocalName.id
}
#Create multiple EPG's
resource "aci_application_epg" "epgLocalName" {
  for_each = var.EPG_VAR
  name = each.key
  application_profile_dn = aci_application_profile.apLocalName.id
  relation_fv_rs_bd = aci_bridge_domain.bd2LocalName[each.value.BD].id
}
# Pull the VMM domain from the APIC controller

data "aci_vmm_domain" "a34-uat-fi-a_vds" {
  provider_profile_dn     = "/uni/vmmp-VMware"
  name                     = "a34-uat-fi-a_vds"
  }

# Assign the VMM domain to EPG
resource "aci_epg_to_domain" "epg_domain" {
  for_each = var.EPG_VAR
  application_epg_dn = aci_application_epg.epgLocalName[each.key].id
  tdn = data.aci_vmm_domain.a34-uat-fi-a_vds.id
  vmm_allow_promiscuous = "reject"
  vmm_forged_transmits  = "accept"
  vmm_mac_changes       = "accept"
}

#Apply the consumer contract on EPG1 (web-app)
resource "aci_epg_to_contract" "Consumer1" {
  for_each = var.Contract_VAR
  application_epg_dn = aci_application_epg.epgLocalName[each.value.EPG1].id
  contract_dn  = aci_contract.Contract1_ct.id
  contract_type = "consumer"
}
#Apply the provider contract on EPG2 (web-app)
resource "aci_epg_to_contract" "provider1" {
  for_each = var.Contract_VAR
  application_epg_dn = aci_application_epg.epgLocalName[each.value.EPG2].id
  contract_dn  = aci_contract.Contract1_ct.id
  contract_type = "provider"
}
#Apply the consumer contract on EPG2 (APP-DB)
resource "aci_epg_to_contract" "Consumer2" {
  for_each = var.Contract_VAR
  application_epg_dn = aci_application_epg.epgLocalName[each.value.EPG2].id
  contract_dn  = aci_contract.Contract2_ct.id
  contract_type = "consumer"
}
#Apply the provider contract on EPG3 (APP-DB)
resource "aci_epg_to_contract" "provider2" {
  for_each = var.Contract_VAR
  application_epg_dn = aci_application_epg.epgLocalName[each.value.EPG3].id
  contract_dn  = aci_contract.Contract2_ct.id
  contract_type = "provider"
}
#ACI Contract1 for WEB_APP
resource "aci_contract" "Contract1_ct"{
  tenant_dn                 = aci_tenant.tenantLocalName.id
  name                        = var.Contract1_name
  scope                    = var.Contract_scope
}
#ACI Contract1 subject
resource "aci_contract_subject" "Contract1_Sub" {
  contract_dn                  = aci_contract.Contract1_ct.id
  name                         = var.Contract1_Sub
  relation_vz_rs_subj_filt_att = [aci_filter.Contract1_filter.id]
}
#ACI Contract1 filter

resource "aci_filter" "Contract1_filter" {
  tenant_dn = aci_tenant.tenantLocalName.id
  name = var.Contract1_filter
}
#ACI Contract1 filter_entry
resource "aci_filter_entry" "filter_entry" {
  for_each = var.Contract_filter_VAR
  name        = each.value.name
  filter_dn   = aci_filter.Contract1_filter.id
  ether_t     = "ip"
  prot       = each.value.prot
  d_to_port = each.value.d_to_port
   stateful    = "yes"
}

#ACI Contract2 for APP_DB
resource "aci_contract" "Contract2_ct"{
  tenant_dn                 = aci_tenant.tenantLocalName.id
  name                        = var.Contract2_name
  scope                    = var.Contract_scope
}
#ACI Contract2 subject
resource "aci_contract_subject" "Contract2_Sub" {
  contract_dn                  = aci_contract.Contract2_ct.id
  name                         = var.Contract2_Sub
  relation_vz_rs_subj_filt_att = [aci_filter.Contract2_filter.id]
}
#ACI Contract2 filter
resource "aci_filter" "Contract2_filter" {
  tenant_dn = aci_tenant.tenantLocalName.id
  name = var.Contract2_filter
}
#ACI Contract2 filter_entry
resource "aci_filter_entry" "filter_entry2" {
  for_each = var.Contract2_filter_VAR
  name        = each.value.name
  filter_dn   = aci_filter.Contract2_filter.id
  ether_t     = "ip"
  prot       = each.value.prot
  d_to_port = each.value.d_to_port
  stateful    = "yes"
}
