variable "name_key" {
  description = "The display/human name of the certificate (without resource_prefix and index)"
  type        = string
}

variable "ca_short_name" {
  description = "Certificate authority short name."
  type        = string
}

variable "subject_alt_names" {
  description = "List of Subject Alternative Names to be used "
  type        = list(string)
}

variable "notifications_email" {
  description = "Technical contact for this certificate"
  type        = string
}

variable "notifications_callback_url" {
  description = "The Url to be used for the callback request for certificate notifications"
  type        = string
  default     = "https://tf-pki-test.fr.world.socgen/testing"
}

variable "notifications_ticketing_group" {
  description = "assignment group to be used if you need a ticket "
  type        = string
  default     = "gts_par_mkt_sec_tsv"
}

variable "tags" {
  description = "List of assets where you will install the certificate."
  type        = set(string)
  default     = ["FQDN", "alias", "IPs", "IP:PORT"]
}

variable "wait_for_revocation" {
  description = "Wheither you want to wait for the revocation at delete"
  type        = bool
  default     = false
}

variable "get_crypto_assets" {
  description = "permit to get crypto assets directly from pki"
  type        = bool
}

variable "subject" {
  description = "Subject Keys parameters"
  type = object({
    # Country Code for the Certificate
    C = string

    # Location for the Certificate
    L = string

    # ST for the Certificate
    ST = string

    # Organization for the Certificate
    O = string

    # Organizational Unit for the Certificate
    OU = string

    # CommonName for the Certificate
    CN = string

  })
}

variable "notifications_callback_payload" {
  description = "A specific payload to include in the callback request for certificate notifications."
  default     = {}
}

variable "remove_name_on_delete" {
  description = "This flag permits to remove some (or all) of the reserved names on the SAN."
  type        = set(string)
  default     = []
}
