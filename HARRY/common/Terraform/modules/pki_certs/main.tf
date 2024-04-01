resource "cloudplatform_pki_certificate_subject_v2" "cert" {
  ca_short_name                  = var.ca_short_name
  subject_alt_names              = var.subject_alt_names
  notifications_email            = var.notifications_email
  notifications_callback_url     = var.notifications_callback_url
  tags                           = var.tags
  notifications_ticketing_group  = var.notifications_ticketing_group
  wait_for_revocation            = var.wait_for_revocation
  subject                        = var.subject
  notifications_callback_payload = var.notifications_callback_payload
  get_crypto_assets              = var.get_crypto_assets
  remove_name_on_delete          = var.remove_name_on_delete
}
