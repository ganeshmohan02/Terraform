#variable "epg_sets" { type = set (string) }
variable tenant_name { type = string }
variable vrf_name    { type = string }
variable "BD_VAR" {type =map (object({
name             = string
description      = string
arp_flood        = string
unicast_route    = string
subnet           = string
}))}
variable "EPG_VAR" {type =map (object({
  name= string
  BD = string
}))}
variable Contract1_name { type = string }
variable Contract1_Sub { type = string }
variable Contract1_filter { type = string }
variable Contract2_name { type = string }
variable Contract2_Sub { type = string }
variable Contract2_filter { type = string }

variable "Contract_filter_VAR" {type =map (object({
    name = string
    prot = string
  d_to_port= string
}))}

variable "Contract2_filter_VAR" {type =map (object({
  name = string
  prot = string
  d_to_port= string
}))}

variable "Contract_VAR" {type = map(object({
    EPG1= string
    EPG2= string
    EPG3= string
}))}
