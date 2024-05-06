# resource "helm_release" "elasticsearch" {
#   name       = "elasticsearch"
#   repository = "https://helm.elastic.co"
#   chart      = "elasticsearch"
#   namespace  = "monitoring"
#   version    = "7.17.3"
#
#   values = [file("${path.module}/values.yaml")]
#
#   set {
#     name  = "node.roles"
#     value = "{master,data,ingest}"
#   }
#
#   set {
#     name  = "node.store.allow_mmap"
#     value = "false"
#   }
#
#   set {
#     name  = "volumeClaimTemplate.resources.requests.storage"
#     value = "10Gi"
#   }
#
#   #   set {
#   #     name  = "volumeClaimTemplate.storageClassName"
#   #     value = "do-block-storage"
#   #   }
#
#   set {
#     name  = "replicas"
#     value = "1"
#   }
#
# }
