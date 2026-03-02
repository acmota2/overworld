set shell := ["bash", "-euo", "pipefail", "-c"]
SEALED_SECRETS_NAME := "sealed-secrets-controller"
SEALED_SECRETS_NAMESPACE := "sealed-secrets"

flux-prod:
  @echo "Bootstrapping Overworld PROD cluster — Ctrl+C to abort"
  sleep 5
  flux bootstrap github \
      --owner=acmota2 \
      --repository=overworld \
      --branch=main \
      --path=clusters/prod \
      --personal

flux-dev:
  @echo "Bootstrapping Overworld DEV cluster — Ctrl+C to abort"
  sleep 5
  flux bootstrap github \
      --owner=acmota2 \
      --repository=overworld \
      --branch=main \
      --path=clusters/dev \
      --personal

create-dev:
  @echo "Creating k3d cluster named 'dev'"
  k3d cluster create dev \
    --image rancher/k3s:v1.35.2-rc1-k3s1 \
    --agents 1 \
    --k3s-arg "--disable=traefik@server:*" \
    --k3s-arg "--disable=local-storage@server:*" \
    -p "80:80@loadbalancer" \
    -p "443:443@loadbalancer" \
    --volume "$(pwd)/k3d-storage:/var/local-path-provisioner@all"

delete-dev:
  @echo "Deleting 'dev' cluster - Ctrl+C to abort"
  sleep 5
  k3d cluster delete dev

seal-all CONTEXT:
  @echo "Sealing all *.secret.yaml files for {{ CONTEXT }}"
  kubeseal --fetch-cert \
      --controller-name={{ SEALED_SECRETS_NAME }} \
      --controller-namespace={{ SEALED_SECRETS_NAMESPACE }} > cert.pem
  
  find . -path './k3d-storage' -prune -o \
  \( -path "./infrastructure/*/{{ CONTEXT }}/*" -o -path "./apps/*/{{ CONTEXT }}/*" \) \
  -name "*.secret.yaml" -type f -print | while read -r secret; do \
      sealed="${secret%.secret.yaml}.sealed.yaml"; \
      echo "  $secret -> $sealed"; \
      kubeseal --format=yaml --cert cert.pem < "$secret" > "$sealed"; \
  done

  rm cert.pem
  @echo "Done."

k-get-all:
    kubectl get all --all-namespaces
