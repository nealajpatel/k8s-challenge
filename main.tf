resource "kind_cluster" "default" {
    name = "example-cluster"
    kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
          role = "control-plane"

          kubeadm_config_patches = [
              "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
          ]

          extra_port_mappings {
              container_port = 80
              host_port      = 80
          }
          extra_port_mappings {
              container_port = 443
              host_port      = 443
          }
      }

      node {
          role = "worker"
      }
  }
}

##########################
### Ingress Controller ###
##########################

data "kubectl_file_documents" "ingress_manifests" {
  content = file("kubernetes/nginx_ingress_controller.yaml")
}

resource "kubectl_manifest" "ingress_controller" {
  count     = length(data.kubectl_file_documents.ingress_manifests.documents)
  yaml_body = element(data.kubectl_file_documents.ingress_manifests.documents, count.index)
}

resource "null_resource" "wait_for_ingress_controller" {
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = "kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s"
  }
  depends_on = [ kubectl_manifest.ingress_controller ]
}

##########################
########## API ###########
##########################

data "kubectl_file_documents" "api_manifests" {
  content = file("kubernetes/api.yaml")
}

resource "kubectl_manifest" "api" {
  count     = length(data.kubectl_file_documents.api_manifests.documents)
  yaml_body = element(data.kubectl_file_documents.api_manifests.documents, count.index)
  wait_for_rollout = false

  depends_on = [ null_resource.wait_for_ingress_controller ]
}

#########################
###### Monitoring #######
#########################

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
}