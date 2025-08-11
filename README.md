# Microservice‑Project

A microservices-based web application built with Python Flask, demonstrating a clean separation of concerns across authentication, gameplay, and frontend delivery using Kubernetes and statically served content.

---
## Prerequisites

Before proceeding, ensure that the following are installed and configured:

1. **Cloud Native PostgreSQL** – Required for database operations within Kubernetes.  
2. **KGateway** – To enable and manage Gateway API functionality.  
3. **Secret Provider** – Since Kubernetes Secrets are only base64-encoded and not secure by default, use a provider like [Secrets Store CSI Driver](https://secrets-store-csi-driver.sigs.k8s.io/) or [External Secrets](https://external-secrets.io/).

---

## 🧩 Architecture Overview

This project is composed of **three microservices**, each implemented using **Python Flask**, and containerized for Kubernetes deployment:

### 1. `authservice`
- Provides **user authentication** (Sign Up and Login).
- Exposes REST APIs for session and credential handling.

### 2. `gameservice`
- Handles all **game logic and state**, including Snake Game mechanics and score management.

### 3. `frontend`
- Uses **Nginx** to statically serve the web interfaces, including:
  - The login page
  - The game UI
- Acts as a reverse proxy to `authservice` and `gameservice`.

---

## 🗄️ Database Layer

- Uses **CloudNativePG** (PostgreSQL operator) to manage the database:
  - Automatic **cluster creation**
  - High availability with **replication**
  - **Persistent storage** enabled by default

### 🔄 Backup Strategy

- Integrated with **Barman** using Kubernetes manifests
- Provides automated backup and restore workflows via:
  - A separate **backup cluster**
  - `Backup` manifest objects for periodic or manual snapshots

---

## ⚙️ Kubernetes Manifests Explained

This project contains Kubernetes manifests to configure various system components:

| Manifest File         | Purpose |
|------------------------|---------|
| `cluster-issuer.yaml` | Defines a **ClusterIssuer** resource to generate HTTPS TLS certificates using **Let's Encrypt** for custom domains specified in your ingress/gateway hostnames. |
| `configmap.yaml`      | Stores **PostgreSQL initialization SQL scripts** (like `init.sql`) used to bootstrap the database (e.g., create tables or seed data). |
| `httpredirect.yaml`   | Configures **HTTP (port 80) redirection to HTTPS (port 443)** for the application's domain. Ensures secure access by default. |
| `httproute.yaml`      | Defines routing rules that forward traffic from path `/` to the **frontend service**, effectively serving the UI. |
| `gateway.yaml`        | Sets up an **API Gateway using Kubernetes Gateway API**. It listens on both ports **80 (HTTP)** and **443 (HTTPS)**, configures the TLS certificate from Let's Encrypt, and routes traffic to appropriate services. |

---

## 🔧 Shell Scripts

The repository also includes `.sh` scripts used to help during development and debugging:

| Script File | Purpose |
|-------------|---------|
| `*.sh`      | Custom shell scripts used to **generate logs** or **tail logs** from individual services (e.g., authservice, gameservice). Helpful for debugging runtime issues and monitoring service health. |

---

## 🌐 Service Discovery

All services are exposed internally in Kubernetes and can be reached using **FQDNs** resolved by **CoreDNS**:

http://<service-name>.<namespace>.svc.cluster.local


🖼️ UI Screenshots

These interfaces are served statically by the frontend service via Nginx:
## 🖼️ UI Screenshots

These interfaces are served **statically by the frontend service** via Nginx:

- 🔐 [Login Page](https://github.com/user-attachments/assets/af2bb125-a9f8-413c-86dc-d81cc1eabe31)
- 🐍 [Snake Game](https://github.com/user-attachments/assets/d47dbbf3-e6fc-4789-8ca1-b2817b63bab0)


## 📈 Autoscaling with HPA

This project uses **Horizontal Pod Autoscaling (HPA)** to automatically scale the number of pods in each microservice deployment based on CPU usage.

### 🛠 How HPA Works

Horizontal Pod Autoscaler monitors the **CPU utilization** of running pods and adjusts the number of pod replicas dynamically to maintain optimal performance and resource efficiency.

We’ve configured HPA for all three microservices with the following target:

- **Target Average CPU Utilization**: `56%`

This configuration ensures that:

- Kubernetes **scales up** the number of pods when CPU usage exceeds 56%
- Kubernetes **scales down** the pods when usage drops below the threshold
- Application performance remains consistent even during traffic spikes


## 🛠 Terraform Integration

This project uses **Terraform** to manage and deploy all Kubernetes manifests in one go.  
Instead of manually running multiple `kubectl apply` commands, you can use Terraform to apply all `.yml` files and services at once.

### How it Works
- Uses the **`kubernetes` provider** (`hashicorp/kubernetes`).
- Loads configuration from your local `~/.kube/config` file to connect to the cluster.
- Uses the `kubernetes_manifest` resource to:
  - Apply **all YAML manifests** from a specified directory.
  - Deploy individual service manifests for each microservice.

Example snippet from our Terraform configuration:
```hcl
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

resource "kubernetes_namespace" "sins" {
  metadata {
    name = "sins"
  }
}

# Apply all manifests in one directory
resource "kubernetes_manifest" "blunt_games" {
  for_each = fileset("/home/Redis/testing", "*.yml")
  manifest = yamldecode(file("~/testing/${each.value}"))
}

# Deploy individual services
resource "kubernetes_manifest" "auth-service" {
  manifest = yamldecode(file("~/testing/auth-service/service.yml"))
}

resource "kubernetes_manifest" "frontend" {
  manifest = yamldecode(file("~/testing/frontend/service.yml"))
}

resource "kubernetes_manifest" "game-service" {
  manifest = yamldecode(file("~/testing/game-service/service.yml"))
}

