########## GLOBAL ##############################################################

app_name  = "ocre"
infra_env = "dev"
region    = "eu-fr-paris"

########## COMPUTE #############################################################

vcs_instances = {
  ocre_appli = {
    description          = "Ocre Appli Machine"
    instance_count       = 1
    names_override       = ["DOCR2K02"]
    tags                 = ["ocre_appli", "dev"]
    availability_zones   = ["eu-fr-paris-1"]
    flavor               = "Large 4vCPU-8GB"
    image                = "WINDOWS STANDARD 2019 GTS"
    disk_size            = "50"
    network              = "AFMO_DEV"
    security_groups = [
      { name_key = "ocre" }
    ]    
  }

  ocre_web = {
    description          = "Ocre Web Machine"
    instance_count       = 1
    names_override       = ["DOCR2K01"]
    tags                 = ["ocre_web", "dev"]
    availability_zones   = ["eu-fr-paris-1"]
    flavor               = "Large 4vCPU-8GB"
    image                = "WINDOWS STANDARD 2019 GTS"
    disk_size            = "50"
    network              = "AFMO_DEV"
    security_groups = [
      { name_key = "ocre" }
    ]    
  }   
}  



########## SECURITY GROUP  ########################################################

security_groups = {
  ocre = {
    description = "ocre (from any IP)"
    tags        = ["ocre", "dev"]
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
