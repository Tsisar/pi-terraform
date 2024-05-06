# Kubernetes dashboard namespace
resource "kubernetes_namespace" "kubernetes_dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
}

# Install kubernetes-dashboard helm chart
resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  namespace  = "kubernetes-dashboard"

  depends_on = [
    kubernetes_namespace.kubernetes_dashboard
  ]
}

# Ingress for Kubernetes Dashboard with HTTPS through cert-manager
# resource "kubernetes_ingress_v1" "kubernetes_dashboard" {
#   metadata {
#     name = "kubernetes-dashboard-ingress"
#     namespace = "kubernetes-dashboard"
#     labels = {
#       "app.kubernetes.io/instance" = "kubernetes-dashboard"
#     }
#     annotations = {
#       "kubernetes.io/ingress.class" = "nginx"
#       "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
#       "nginx.ingress.kubernetes.io/secure-backends" = "true"
#       "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
#     }
#   }
#
#   spec {
#     rule {
#       host = "dashboard.${var.domain}"
#       http {
#         path {
#           backend {
#             service {
#               name = "kubernetes-dashboard-kong-proxy"
#               port {
#                 number = 443
#               }
#             }
#           }
#           path     = "/"
#           path_type = "Prefix"
#         }
#       }
#     }
#
#     tls {
#       hosts = ["dashboard.${var.domain}"]
#       secret_name = "kubernetes-dashboard-tls"
#     }
#   }
#
#   depends_on = [
#     helm_release.kubernetes_dashboard
#   ]
# }
