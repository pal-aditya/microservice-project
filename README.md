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

- Services communicate over Kubernetes networking using: http://authservice.sins.svc.cluster.local

🖼️ UI Screenshots

These interfaces are served statically by the frontend service via Nginx:
🔐 Login Page
<img width="738" height="823" alt="Login UI" src="https://github.com/user-attachments/assets/af2bb125-a9f8-413c-86dc-d81cc1eabe31" />
🐍 Snake Game
<img width="953" height="818" alt="Snake Game" src="https://github.com/user-attachments/assets/d47dbbf3-e6fc-4789-8ca1-b2817b63bab0" />
