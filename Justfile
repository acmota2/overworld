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

