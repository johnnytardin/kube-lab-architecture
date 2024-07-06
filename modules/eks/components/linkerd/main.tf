resource "tls_private_key" "trustanchor_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "trustanchor_cert" {
  private_key_pem       = tls_private_key.trustanchor_key.private_key_pem
  validity_period_hours = 87600
  is_ca_certificate     = true

  subject {
    common_name = "identity.linkerd.cluster.local"
  }

  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

# Issuer Certificate

resource "tls_private_key" "issuer_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "issuer_req" {
  private_key_pem = tls_private_key.issuer_key.private_key_pem

  subject {
    common_name = "identity.linkerd.cluster.local"
  }
}

resource "tls_locally_signed_cert" "issuer_cert" {
  cert_request_pem      = tls_cert_request.issuer_req.cert_request_pem
  ca_private_key_pem    = tls_private_key.trustanchor_key.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.trustanchor_cert.cert_pem
  validity_period_hours = 87600
  early_renewal_hours   = var.linkerd_identity_validity_period_hours
  is_ca_certificate     = true

  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

resource "helm_release" "linkerd-crds" {
  count = local.component.enabled == false ? 0 : 1

  name             = "linkerd-crds"
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-crds"
  version          = "1.8.0"
  create_namespace = true
  namespace        = local.component.namespace
}

resource "helm_release" "linkerd-jaeger" {
  count = local.component.enabled == false || local.component.enable_jaeger == false ? 0 : 1

  name             = "linkerd-jaeger"
  chart            = "linkerd-jaeger"
  repository       = "https://helm.linkerd.io/stable"
  version          = "30.12.11"
  create_namespace = true
  namespace        = "linkerd-jaeger"
  values           = [local.jaeger_values]

  set {
    name  = "linkerdVersion"
    value = "30.4.5"
  }

  depends_on = [
    helm_release.linkerd-crds,
    helm_release.linkerd-control-plane
  ]
}

resource "helm_release" "linkerd-viz" {
  count = local.component.enabled == false || local.component.enable_viz == false ? 0 : 1

  name             = "linkerd-viz"
  chart            = "linkerd-viz"
  repository       = "https://helm.linkerd.io/stable"
  version          = "30.12.11"
  create_namespace = true
  namespace        = "linkerd-viz"
  values           = [file("${path.module}/viz-values.yaml")]

  depends_on = [
    helm_release.linkerd-crds,
    helm_release.linkerd-control-plane
  ]
}

resource "helm_release" "linkerd-control-plane" {
  count = local.component.enabled == false ? 0 : 1

  name             = "linkerd-control-plane"
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-control-plane"
  version          = "1.16.11"
  create_namespace = true
  namespace        = local.component.namespace
  values           = [file("${path.module}/values.yaml")]

  set_sensitive {
    name  = "identityTrustAnchorsPEM"
    value = tls_self_signed_cert.trustanchor_cert.cert_pem
  }

  set_sensitive {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_locally_signed_cert.issuer_cert.cert_pem
  }

  set_sensitive {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.issuer_key.private_key_pem
  }

  set {
    name  = "identity.issuer.crtExpiry"
    value = tls_locally_signed_cert.issuer_cert.validity_end_time
  }

}
