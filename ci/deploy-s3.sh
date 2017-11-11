#!/usr/bin/env bash

set -euf -o pipefail

if [[ ! ${!BUILD_ARTIFACT[@]} ]]; then
  >&2 echo "BUILD_ARTIFACT must be set"
  exit 1
fi

if [[ ! ${!S3_BUCKET[@]} ]]; then
  >&2 echo "S3_BUCKET must be set"
  exit 1
fi

if [[ ! ${!DEPLOY_NAME[@]} ]]; then
  >&2 echo "DEPLOY_NAME must be set"
  exit 1
fi

(cat "${BUILD_ARTIFACT}" | mc pipe deploy/${S3_BUCKET}/${DEPLOY_NAME}) 5>&1 | md5sum - > "${DEPLOY_NAME}.md5"

# fetch data back from s3 and check md5
mc cat deploy/${S3_BUCKET}/${DEPLOY_NAME} | md5sum -c "${DEPLOY_NAME}.md5"

echo "Uploaded ${DEPLOY_NAME} to ${S3_BUCKET} with md5: $(cat ${DEPLOY_NAME}.md5)"
