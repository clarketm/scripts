#!/usr/bin/env bash

set -euxo pipefail

pwd

ls -laR

# Extract tag from manifest.
export TAG=$(grep -Pom1 'image:.*:\K\d{1,3}\.\d{1,3}.\d{1,3}' "./cluster/addons/istio/auth/istio-auth.yaml")
export JUNIT_E2E_XML="${ARTIFACTS}/junit.xml"
export TARGET=e2e_bookinfo_envoyv2_v1alpha3
export E2E_ARGS='--skip_setup --namespace=istio-system --test.run=Test[^DbRoutingMysql]'

cd ../../../istio.io/istio || exit 1

git checkout "$TAG"

make with_junit_report

gcloud beta container clusters update istio-e2e --project="$PROJECT" --zone="$ZONE" --update-addons=Istio=DISABLED
