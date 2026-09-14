# Overworld: declarative Kubernetes homelab

This repository represents the cluster base of my homelab. All services this cluster doesn't depend on will live in the cluster.

The project exists both as a personal platform and as a place to explore practical Kubernetes operations.

[`Blaze`](https://github.com/acmota2/blaze) represents the base of all machines of my homelab.

---

## Scope and constraints

This cluster currently runs on a single node, with 32GB of RAM available to Kubernetes, and a single-disk storage setup.

The only manual step required to bootstrap a fresh cluster from this repository is re-sealing secrets. Everything else is reconciled automatically.

---

## Cluster stack

The cluster is built around a small set of foundational components that everything else depends on:

- **Kubernetes distribution:**
  - k3s (prod)
  - k3d (dev)
- **GitOps:** FluxCD
- **Load balancing:** MetalLB
- **Networking:** Kubernetes Gateway API (Envoy Gateway)
- **TLS:** cert-manager (DNS-01)
- **Storage:** Longhorn

To support stateful applications, there's also the following shared services:

- **PostgreSQL:** CloudNativePG  
- **In-memory store:** Dragonfly  
- **Object storage:** Garage (moving away from MinIO)
- **DNS automation:** external-dns (Pi-hole integration)  
- **Secrets:** Infisical + External Secrets Operator, with SOPS / Sealed Secrets for bootstrap credentials  
- Custom Cloudflared tunnel

---

## Roadmap

Future work is intentionally incremental and influenced by currently available:

- Gradually migrate additional services onto the platform as storage and capacity allow.
- Continue reducing bootstrap friction where possible.

There is no fixed end state, the platform will evolve continuosly.

---

## Inspirations

- [athena-ops](https://github.com/eivarin/athena-ops), a Talos-based Kubernetes cluster that helped shape how I think about treating a homelab as a real platform.
- [Dreams of Autonomy](https://www.youtube.com/@dreamsofautonomy), particularly around running Kubernetes on NixOS planes.
