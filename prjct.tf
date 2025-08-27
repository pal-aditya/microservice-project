terraform {
  required_providers {
    kubernetes = {
      version = "~> 2.0"
      source  = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_manifest" "blunt_games" {
  for_each = fileset("/home/Redis/testing", "*.yml")
  manifest = yamldecode(file("~/testing/${each.value}"))
}
resource "kubernetes_manifest" "auth-service" {
  manifest = yamldecode(file("~/testing/auth-service/service.yml"))
}

resource "kubernetes_manifest" "services" {
  manifest = yamldecode(file("~/testing/auth-service/service.yml"))
}

resource "kubernetes_manifest" "frontend" {
  manifest = yamldecode(file("~/testing/frontend/service.yml"))
}

resource "kubernetes_manifest" "game-service" {
  manifest = yamldecode(file("~/testing/game-service/service.yml"))
}


#data "external" cnpostgress"{
#  program = ["bash", "-c" <<EOT
#  content = $(curl -O https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.25/releases/cnpg-1.25.3.yaml)
#  EOT
#  ]
#}

#resource "kubernetes_manifest" "postgressinstall"{
#  manifest = yamldecode(data.http.cnpostgress.body)
#}

# Install kgateway CRD's
#resource "helm_release" "kgateway" {
#  name = "kgateway-crds"
#  repository = "oci://cr.kgateway.dev/kgateway-dev/charts"
#  chart      = "kgateway-crds"
#  version    = "2.0.4"
#  namespace  = kubernetes_namespace.kgateway.metadata[0].name
#}

# Install kgateway
#resource "helm_release" "kgateway" {
# name       = "kgateway"
#  repository = "oci://cr.kgateway.dev/kgateway-dev/charts"
#  chart      = "kgateway"
#  version    = "2.0.4"
#  namespace  = kubernetes_namespace.kgateway.metadata[0].name
#  depends_on = [helm_release.kgateway_crds]
#}

#data "external" "cnpostgress" {
#  program = ["bash", "-c", <<EOT
#    content=$(curl -s -L https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.25/releases/cnpg-1.25.3.yaml)
#    jq -n --arg content "$content" '{content:$content}'
#  EOT
#  ]
#}

#resource "kubernetes_manifest" "cnpg" {
#  manifest = yamldecode(data.external.cnpostgress.result["content"])
#}



#data "external" "cert" {
#  program = ["bash", "-c", <<EOT
#  content = $(curl -s -L https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml)
#  jq -n --arg content "$content" '{content:$content}'
#  EOT
#  ]
#}

#resource "kubernetes_manifest" "certmanager" {
#  manifest = yamldecode(data.external.cert.result["content"])
#}


#resource "kubernetes_manifest" "cnpg"{
#  manifest = yamldecode(data.external.cnpostgress.content)
#}
