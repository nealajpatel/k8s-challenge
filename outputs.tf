output "kubeconfig" {
  value = kind_cluster.default.kubeconfig
}

output "grafana_credentials" {
  value = {
    username = "admin"
    password = "prom-operator"
  }
}