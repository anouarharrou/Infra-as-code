output "cert" {
  value = cloudplatform_pki_certificate_subject_v2.cert.id
}


output "cert_pem" {
  value = cloudplatform_pki_certificate_subject_v2.cert.pem
}

output "cert_private_key_no_passphrase" {
  value     = cloudplatform_pki_certificate_subject_v2.cert.private_key_no_passphrase
  sensitive = true
}

output "cert_passphrase" {
  value     = cloudplatform_pki_certificate_subject_v2.cert.passphrase
  sensitive = true
}
