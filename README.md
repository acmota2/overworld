# Overworld: declarative Kubernetes homelab

This repository documents the migration of my homelab services from a NixOS-based Docker Compose system ([`Blaze`](https://github.com/acmota2/blaze)) to a fully declarative, GitOps-managed Kubernetes cluster. `Blaze` will continue to be the base for the k8s machine cofiguration.

The primary goal is to build a robust and reproducible environment for self-hosting services, managed 100% via [FluxCD](https://fluxcd.io/). This project also serves as an r&d platform for exploring declarative configuration, service discovery, and cloud-native best practices.

## Project Goals

* **Declarative Migration:** Evolve from a single-node declarative system (NixOS) to a distributed, cluster-native one (Kubernetes).
* **100% GitOps:** All cluster state (applications and infrastructure) must be defined in this Git repository and reconciled by FluxCD.
* **Platform Agnostic:** The core stack is intended to run on any K8s distribution (currently K3s).
* **Reproducibility:** A new cluster should be bootstrap-able from this repository with minimal manual steps.

---

## Core Infrastructure Stack

This is the stable foundation of the `prod` cluster.

* **Distribution:** [K3s](https://k3s.io/)
* **GitOps:** [FluxCD](https://fluxcd.io/)
* **Load balancing:** [Metallb](https://metallb.universe.tf/)
* **Ingress controller:** [ingress-nginx](https://kubernetes.github.io/ingress-nginx/) (currently evaluating Traefik for performance and configuration)
* **TLS certificates:** [cert-manager](https://cert-manager.io/)
* **Storage:** [Longhorn](https://longhorn.io/)

## Platform Services

This is the evolving stack of services being built on top of the core infrastructure to support stateful, production-grade applications.

* **Database:** [CloudNativePG](https://cloudnative-pg.io/) (PostgreSQL Operator)
* **In-Memory Cache:** [Dragonfly](https://www.dragonflydb.io/) (High-performance Redis-compatible store)
* **S3-Compatible Storage:** [MinIO](https://min.io/) (For database snapshots and application object storage)
* **Service Discovery:** [external-dns](https://github.com/kubernetes-sigs/external-dns) (Syncing Ingress records to an internal Pi-hole DNS)
* **Secrets Management:** A three-tiered strategy:
    * **`SOPS` / `Sealed Secrets`:** For root credentials (e.g. infisical's own token).
    * **`Infisical`:** Central management for all application secrets.
    * **`External Secrets Operator`:** Operator to pull secrets from Infisical and sync them as `Secret` objects in the cluster.

---

## Current Status

### Deployed & Stable
* **Core Services:** The entire "Core Infrastructure Stack" (`metallb`, `cert-manager`, `longhorn`) is stable and reconciling via Flux.
* **Platform Services:** The "Advanced Platform Services" (`CloudNativePG`, `Dragonfly`, `MinIO`, `external-dns`) are deployed, reconciling, and ready for application consumption.

### Under Active Development
* **Monitoring stack:** The `kube-prometheus-stack` (Grafana, Prometheus) is currently non-functional.

### Future Roadmap
* **R&D sandbox (dev cluster):** Build the `clusters/dev` environment using [k3d](https://k3d.io/). This will serve as a testing environment for new technologies and applications.
* **Promote to prod:** Approved applications and services from the `dev` cluster will be promoted to the `prod` cluster.
* **Fix monitoring:** Migrate the `kube-prometheus-stack` to use the new `CloudNativePG` instance for its Grafana database and the `MinIO` instance for long-term storage.
* **Deploy `Immich`:** Redeploy the `Immich` application declaratively via Flux, configured to use `CloudNativePG` for its database and `MinIO` for object storage.
* **Deploy previous stack from `Blaze`:** Migrate other applications from the previous `Blaze` homelab to the new Kubernetes cluster.
* **Integrate secrets:** Migrate application secrets into `Infisical` to be pulled into the cluster via the `External Secrets Operator`.

## Inspirations

This project's architecture did not come out of a vacuum. It was heavily inspired by the work of:

* My friend's Talos-based Kubernetes cluster, [athena-ops](https://github.com/eivarin/athena-ops), which served as the initial inspiration for running a homelab in Kubernetes.
* [DreamsOfAutonomy (YouTube Channel)](https://www.youtube.com/@dreamsofautonomy) - For the foundational concepts on running K3s declaratively on NixOS, which was a massive help in bridging the `Blaze` and `Overworld` projects.
