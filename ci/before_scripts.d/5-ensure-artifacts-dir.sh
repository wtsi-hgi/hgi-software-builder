if [[ ! ${!GITLAB_ARTIFACTS_DIR[@]} ]]; then
  >&2 echo "GITLAB_ARTIFACTS_DIR must be set in gitlab secret vars"
  exit 1
fi

mkdir -p "${GITLAB_ARTIFACTS_DIR}"
