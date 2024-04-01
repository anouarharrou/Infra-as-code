# TODO: add version constraints (tf version and providers)
terraform {
  required_version = ">= 1.2"
  required_providers {
    cloudplatform = {
      source = "tfregistry.cloud.socgen/gts/cloudplatform"
    }
    null = {
      source  = "tfregistry.cloud.socgen/hashicorp/null"
      version = ">= 3.1.1"
    }
  }
}

provider "cloudplatform" {
  region       = var.region
  default_tags = local.default_tags
}



