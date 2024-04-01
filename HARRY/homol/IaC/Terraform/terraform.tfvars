########## GLOBAL ##############################################################

app_name  = "ocre"
infra_env = "homol"
region    = "eu-fr-paris"

########## COMPUTE #############################################################

vcs_instances = {
  ocre_appli = {
    description          = "Ocre Appli Machine"
    instance_count       = 1
    names_override       = ["HOCR2K22"]
    tags                 = ["ocre_appli", "homol"]
    availability_zones   = ["eu-fr-paris-1"]
    flavor               = "XLarge 8vCPU-16GB"
    image                = "WINDOWS STANDARD 2019 GTS"
    disk_size            = "100"
    network              = "AFMO_HOM"
    security_groups = [
      { name_key = "ocre" }
    ]    
  }

  ocre_web = {
    description          = "Ocre Web Machine"
    instance_count       = 1
    names_override       = ["HOCR2K21"]
    tags                 = ["ocre_web", "homol"]
    availability_zones   = ["eu-fr-paris-1"]
    flavor               = "XLarge 8vCPU-16GB"
    image                = "WINDOWS STANDARD 2019 GTS"
    disk_size            = "100"
    network              = "AFMO_HOM"
    security_groups = [
      { name_key = "ocre" }
    ]    
  }  
}

########## SECURITY GROUP  ########################################################

security_groups = {
  ocre = {
    description = "ocre (from any IP)"
    tags        = ["ocre", "homol"]
    ecosystem   = "vcs"
    rules = [
      {
        description  = "rdp ingress"
        direction    = "ingress"
        remote_type  = "ipRange"
        remote_value = "0.0.0.0/0"
        protocol     = "tcp"
        port_range   = "3389-3389"
      }
    ]
  }
}
