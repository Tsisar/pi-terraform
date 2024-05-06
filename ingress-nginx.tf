# Create ingress-nginx namespace
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

# Install ingress-nginx helm chart
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

    set {
        name  = "controller.service.type"
        value = "LoadBalancer"
    }

    set {
        name  = "controller.service.nodePorts.http"
        value = "30080"
    }

    set {
        name  = "controller.service.nodePorts.https"
        value = "30443"
    }

  depends_on = [
    kubernetes_namespace.ingress_nginx
  ]
}

