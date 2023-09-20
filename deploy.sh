#!/usr/bin/env bash

gcloud run deploy ui supanuxtphile \
  --image us-central1-docker.pkg.dev/supanuxtphile/supanuxtphile/ui-supanuxtphile \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated