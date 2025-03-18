resource "kubernetes_namespace" "creates" {
  count = length(var.namespaces)
  metadata {
    name = element(var.namespaces, count.index)
  }
}