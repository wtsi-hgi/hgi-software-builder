if [[ ! ${!S3_ACCESS_KEY[@]} ]]; then
  >&2 echo "S3_ACCESS_KEY must be set in gitlab secret vars"
  exit 1
fi
if [[ ! ${!S3_HOST[@]} ]]; then
  >&2 echo "S3_HOST must be set in gitlab secret vars"
  exit 1
fi
if [[ ! ${!S3_SECRET_KEY[@]} ]]; then
  >&2 echo "S3_SECRET_KEY must be set in gitlab secret vars"
  exit 1
fi
