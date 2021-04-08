#epg_sets = ["WEB_epg","APP_epg","DB_epg"]
tenant_name ="Devnet6"
vrf_name ="Devnet6_vrf"
Contract1_name = "WEB_APP_ct"
Contract1_Sub = "WEB_APP_sub"
Contract1_filter = "WEB_APP_filter"
Contract2_name = "APP_DB_ct"
Contract2_Sub = "APP_DB_sub"
Contract2_filter = "APP_DB_filter"

BD_VAR = {
  "WEB_bd"={
    name             = "WEB_bd"
    description      = "Application Core bridge"
    arp_flood        = "no"
    unicast_route    = "yes"
    subnet           = "1.1.10.1/24"
  }
  "APP_bd"={
      name             = "APP_bd"
      description      = "Application Core bridge"
      arp_flood        = "no"
      unicast_route    = "yes"
      subnet           = "1.1.20.1/24"
    }
  "DB_bd" = {
        name = "DB_bd"
        description = "Application Core bridge"
        arp_flood = "no"
        unicast_route = "yes"
        subnet = "1.1.30.1/24"
      }}

  EPG_VAR = {
    "WEB_epg" = {
      name="WEB_epg"
      BD = "WEB_bd"  }
    "APP_epg" = {
      name="APP_epg"
      BD = "APP_bd"  }
    "DB_epg" = {
      name="DB_epg"
      BD = "DB_bd"    } }


Contract_VAR = {
  "Contract_VAR" = {
  EPG1="WEB_epg"
  EPG2="APP_epg"
  EPG3="DB_epg" }}


Contract_filter_VAR= {
  "icmp" = {
  name = "icmp"
  prot = "icmp"
    d_to_port =""
  }
  "SSH" = {
    name = "SSH"
    prot = "tcp"
    d_to_port ="22"
  }
  "HTTPS" = {
    name = "HTTPS"
    prot = "tcp"
    d_to_port ="443"
  }
}

Contract2_filter_VAR= {
"icmp" = {
name = "icmp"
prot = "icmp"
d_to_port =""
}
"SSH" = {
name = "SSH"
prot = "tcp"
d_to_port ="22"
}
"TCP_DB_1512" = {
name = "TCP_DB_1512"
prot = "tcp"
d_to_port ="1512"
}
}