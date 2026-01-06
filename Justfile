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

seal-all:
    @echo "Fetching Sealed Secrets public certificate..."

    @echo "Sealing all *.secret.yaml files..."
    find . -name '*.secret.yaml' -type f | while read -r secret; do \
        sealed="${secret%.secret.yaml}.sealed.yaml"; \
        echo "  $secret -> $sealed"; \
        kubeseal \
          --format=yaml \
          --cert <(kubeseal \
            --fetch-cert \
            --controller-name={{SEALED_SECRETS_NAME}} \
            --controller-namespace={{SEALED_SECRETS_NAMESPACE}}) \
          < "$secret" \
          > "$sealed"; \
    done

    @echo "Done."

k-get-all:
    kubectl get all --all-namespaces
