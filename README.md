# Microservice‑Project

A microservices-based web application built using Python Flask, featuring a modular architecture with authentication, game logic, and a user interface, all deployed via Kubernetes.

## 🧩 Architecture Overview

This project consists of **three microservices**, each built using **Python Flask** and containerized for deployment:

### 1. `authservice`
- Handles user **authentication**, including **Sign Up** and **Login**.
- Exposes REST endpoints for secure session and credential management.

### 2. `gameservice`
- Manages game-related data and logic.
- Powers a basic Snake Game using a grid-based UI.
- Provides APIs or routes for game state and score updates.

### 3. `frontend`
- Uses **Nginx** to serve static webpages and acts as a reverse proxy for Flask services.
- Serves both the **Snake Game interface** and **Login UI**.
- Connects with `authservice` and `gameservice` via HTTP.

## 🗄️ Database Layer

- Uses **CloudNativePG (PostgreSQL Operator)** for managing the PostgreSQL database.
- The operator handles:
  - **High availability** with automated cluster creation and management.
  - **Replica setup** and **persistent storage**.
  - Seamless backup using **Barman** integration.

### Backup Management

- A **Kubernetes manifest** is provided to:
  - Spin up a **Barman backup cluster**.
  - Schedule and manage **PostgreSQL backups** using Barman.

## ⚙️ Deployment Details

- Each microservice has a **Kubernetes Deployment** and **Service**.
- Services are resolved using **FQDNs** (Fully Qualified Domain Names) through **CoreDNS**, enabling reliable inter-service communication.

## 🔗 Internal Communication

- Services communicate over Kubernetes networking using:

http://<service-name>.<namespace>.svc.cluster.local

Example:
```http
http://authservice.sins.svc.cluster.local


<img width="738" height="823" alt="Screenshot 2025-08-07 131121" src="https://github.com/user-attachments/assets/01a51d5e-4703-416f-a470-df513defbb4f" />
<img width="953" height="818" alt="Screenshot 2025-08-07 131230" src="https://github.com/user-attachments/assets/f03ad5ce-d602-4634-ae71-5f0166d4076d" />
