terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.0.16"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "kind" {
  # Configuration options
}

resource "kind_cluster" "default" {
  name = "static"
  wait_for_ready = true

  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-pane"

      extra_port_mappings {
        container_port = 30950
        host_port = 30950
      }
    }
  }

  provisioner "local-exec" {
    command = <<EOT
      docker build -t hello-world:v1 .
      kind load docker-image hello-world:v1 --name static
    EOT
  }
}

provider "kubectl" {
  host                   = kind_cluster.default.endpoint
  cluster_ca_certificate = kind_cluster.default.cluster_ca_certificate
  client_certificate     = kind_cluster.default.client_certificate
  client_key             = kind_cluster.default.client_key
}

data "kubectl_file_documents" "deployment" {
  content = file("site-deployment.yml")
}

resource "kubectl_manifest" "deployment_apply" {
  for_each  = data.kubectl_file_documents.deployment.manifests
  yaml_body = each.value
  wait = true
  server_side_apply = true
}

data "kubectl_file_documents" "service" {
  content = file("site-service.yml")
}

resource "kubectl_manifest" "service_apply" {
  for_each  = data.kubectl_file_documents.service.manifests
  yaml_body = each.value
  wait = true
  server_side_apply = true
}
