variable tenant_name { default = "Devnet7"  }
variable vrf_name    { default = "Devnet7_vrf" }
variable Contract1_name { default = "WEB_APP_ct" }
variable Contract1_Sub { default = "WEB_APP_sub"}
variable Contract1_filter {default = "WEB_APP_filter" }
variable Contract2_name { default = "APP_DB_ct"}
variable Contract2_Sub { default = "APP_DB_sub" }
variable Contract2_filter { default = "APP_DB_filter" }
variable Contract_scope {default = "tenant"  }

variable "BD_VAR" {
type = map
default = {
WEB_bd ={
name             = "WEB_bd"
description      = "Application Core bridge"
arp_flood        = "no"
unicast_route    = "yes"
subnet           = "1.1.10.1/24"
},
APP_bd ={
name             = "APP_bd"
description      = "Application Core bridge"
arp_flood        = "no"
unicast_route    = "yes"
subnet           = "1.1.20.1/24"
},
DB_bd = {
name = "DB_bd"
description = "Application Core bridge"
arp_flood = "no"
unicast_route = "yes"
subnet = "1.1.30.1/24"
},
}
}


variable "EPG_VAR" {
type = map
default = {
"WEB_epg" = {
name="WEB_epg"
BD = "WEB_bd"
},
"APP_epg" = {
name="APP_epg"
BD = "APP_bd"
},
"DB_epg" = {
name="DB_epg"
BD = "DB_bd"
},
}
}


variable "Contract_VAR"  {
type = map
default ={
"Contract_VAR" = {
EPG1="WEB_epg"
EPG2="APP_epg"
EPG3="DB_epg" }
}
}


variable "Contract_filter_VAR"  {
type = map
default ={
"icmp" = {
name = "icmp"
prot = "icmp"
d_to_port =""
},
"SSH" = {
name = "SSH"
prot = "tcp"
d_to_port ="22"
},
"HTTPS" = {
name = "HTTPS"
prot = "tcp"
d_to_port ="443"
},
}
}
variable "Contract2_filter_VAR" {
type = map
default ={
"icmp" = {
name = "icmp"
prot = "icmp"
d_to_port =""
},
"SSH" = {
name = "SSH"
prot = "tcp"
d_to_port ="22"
},
"TCP_DB_1512" = {
name = "TCP_DB_1512"
prot = "tcp"
d_to_port ="1512"
},
}
}
