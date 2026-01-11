# Overworld: declarative Kubernetes homelab

This repository represents the migration of my homelab services from a NixOS and podman based setup to a fully declarative, FluxCD managed Kubernetes cluster. NixOS remains the base for machine configuration and provisioning, while Kubernetes is used as the runtime and orchestration layer.

The project exists both as a personal platform and as a place to explore practical Kubernetes operations, even when with limited hardware and storage.

[`Blaze`](https://github.com/acmota2/blaze) continues to exist as the base system configuration used to provision the machines that run this cluster.

---

## Scope and constraints

This cluster currently runs on a small amount of hardware, with roughly 20 GB of RAM available to Kubernetes, and a single-disk storage setup. Those constraints directly influence design decisions: simpler control planes, conservative storage management, and avoiding components that assume unconstrained hardware.

The only manual step required to bootstrap a fresh cluster from this repository is re-sealing secrets. Everything else is reconciled automatically.

---

## Cluster stack

The cluster is built around a small set of foundational components that everything else depends on:

- **Kubernetes distribution:**
  - k3s (prod)
- **GitOps:** FluxCD
- **Load balancing:** MetalLB
- **Networking:** Kubernetes Gateway API (Envoy Gateway)
- **TLS:** cert-manager (DNS-01)
- **Storage:** Longhorn

To support stateful applications, there's also the following shared services:

- **PostgreSQL:** CloudNativePG  
- **In-memory store:** Dragonfly  
- **Object storage:** MinIO  
- **DNS automation:** external-dns (Pi-hole integration)  
- **Secrets:** Infisical + External Secrets Operator, with SOPS / Sealed Secrets for bootstrap credentials  

Applications are treated separately and are expected to grow over time, so they are not listed here.

---

## Current state

The cluster reconciles cleanly via Flux and is actively used. Networking, TLS, storage, and secret distribution are all handled declaratively. Services like MinIO, Infisical, Longhorn, and monitoring components are exposed via the Gateway API and secured with proper certificates.

This repository represents a working baseline that can be rebuilt.

---

## Roadmap

Future work is intentionally incremental and influenced by currently available:

- Introduce a lightweight `dev` cluster that can run locally for testing changes before promotion.
- Gradually migrate additional services onto the platform as storage and capacity allow.
- Improve monitoring persistence and backup strategies once underlying storage constraints are addressed.
- Continue reducing bootstrap friction where possible.

There is no fixed end state, the platform will evolve from a working baseline.

---

## Inspirations

- [athena-ops](https://github.com/eivarin/athena-ops), a Talos-based Kubernetes cluster that helped shape how I think about treating a homelab as a real platform.
- [Dreams of Autonomy](https://www.youtube.com/@dreamsofautonomy), particularly around running Kubernetes on NixOS planes.
