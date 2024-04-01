terraform {
  backend "s3" {
    # // The additional elements are mandatory as we don't use AWS S3 offer
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}