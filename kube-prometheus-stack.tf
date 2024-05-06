# Create kube-prometheus-stack namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# Create kube-prometheus-stack helm release
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  set {
    name  = "prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues"
    value = "false"
  }

  set {
    name  = "grafana.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "20Gi"
  }

  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "30d"
  }

  set {
    name  = "prometheus.prometheusSpec.retentionSize"
    value = "19GB"
  }

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}

# Create basic auth secret
resource "kubernetes_secret" "prometheus-basic-auth" {
  metadata {
    name = "prometheus-basic-auth"
    namespace = "monitoring"
  }

  data = {
    auth = file("${path.module}/.auth/prometheus")
  }
}

# Create prometheus ingress
# resource "kubernetes_ingress_v1" "prometheus_ingress" {
#   metadata {
#     name      = "prometheus-ingress"
#     namespace = "monitoring"
#     labels = {
#       "app.kubernetes.io/instance" = "kube-prometheus-stack"
#       "app.kubernetes.io/name" = "prometheus"
#     }
#     annotations = {
#       "kubernetes.io/ingress.class" = "nginx"
#       "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
#       "alb.ingress.kubernetes.io/ssl-passthrough" = "true"
#       "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
#       "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
#       "nginx.ingress.kubernetes.io/auth-type" = "basic"
#       "nginx.ingress.kubernetes.io/auth-secret" = "prometheus-basic-auth"
#     }
#   }
#
#   spec {
#     rule {
#       host = "prometheus.${var.domain}"
#       http {
#         path {
#           backend {
#             service {
#               name = "prometheus-operated"
#               port {
#                 number = 9090
#               }
#             }
#           }
#           path     = "/"
#           path_type = "Prefix"
#         }
#       }
#     }
#     tls {
#       hosts = ["prometheus.${var.domain}"]
#       secret_name = "prometheus-tls"
#     }
#   }
#
#   depends_on = [
#     helm_release.kube_prometheus_stack
#   ]
# }

# Create grafana ingress
# resource "kubernetes_ingress_v1" "grafana_ingress" {
#   metadata {
#     name      = "grafana-ingress"
#     namespace = "monitoring"
#     labels = {
#       "app.kubernetes.io/instance" = "kube-prometheus-stack"
#       "app.kubernetes.io/name" = "prometheus"
#     }
#     annotations = {
#       "kubernetes.io/ingress.class" = "nginx"
#       "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
#       "alb.ingress.kubernetes.io/ssl-passthrough" = "true"
#       "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
#       "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
#     }
#   }
#
#   spec {
#     rule {
#       host = "grafana.${var.domain}"
#       http {
#         path {
#           backend {
#             service {
#               name = "kube-prometheus-stack-grafana"
#               port {
#                 number = 80
#               }
#             }
#           }
#           path     = "/"
#           path_type = "Prefix"
#         }
#       }
#     }
#     tls {
#       hosts = ["grafana.${var.domain}"]
#       secret_name = "grafana-tls"
#     }
#   }
#
#   depends_on = [
#     helm_release.kube_prometheus_stack
#   ]
# }