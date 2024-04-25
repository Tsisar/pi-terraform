# Create argo-cd namespace
resource "kubernetes_namespace" "argo_cd" {
  metadata {
    name = "argo-cd"
  }
}

# Install ArgoCD
resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argo-cd"

  depends_on = [
    kubernetes_namespace.argo_cd
  ]
}

# Ingress resource for Argo CD with Let's Encrypt certificate
resource "kubernetes_ingress_v1" "argo_cd" {
  metadata {
    name      = "argo-cd-ingress"
    namespace = "argo-cd"
    labels = {
      "app.kubernetes.io/instance" = "argo-cd"
    }
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      "alb.ingress.kubernetes.io/ssl-passthrough" = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
    }
  }

  spec {
    rule {
      host = "argo.${var.domain}"
      http {
        path {
          backend {
            service {
              name = "argo-cd-argocd-server"
              port {
                number = 443
              }
            }
          }
          path     = "/"
          path_type = "Prefix"
        }
      }
    }

    tls {
      hosts = ["argo.${var.domain}"]
      secret_name = "argo-tls"
    }
  }

  depends_on = [
    helm_release.argo_cd
  ]
}
