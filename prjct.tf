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
