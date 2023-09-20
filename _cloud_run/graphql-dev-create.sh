
gcloud run deploy ovb-api-graphql \
  --project dev-ovb \
  --image us-central1-docker.pkg.dev/dev-ovb/dev-ovb/ovb-api \
  # --image gcr.io/dev-ovb/ovb-api \
  --vpc-connector ovb-vpc-connector \
  --allow-unauthenticated 
  # --set-env-vars SCHEMATA_TO_GRAPHQL="app,appc,msg,bill,ovb,ovbp,ovb_public,auth_fn,app_fn,app_fn_public,msg_fn,bill_fn,ovb_fn,prj,prj_fn,ovb_mport,hlp,hlp_fn" \
