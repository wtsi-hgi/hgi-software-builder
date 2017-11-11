export VERSION=$(${VERSION_COMMAND})
if [[ $? -ne 0 ]]; then
    echo "VERSION_COMMAND exited with error $?"
    exit $?
fi

if [[ -z "${VERSION}" ]]; then
    echo "VERSION_COMMAND \"${VERSION_COMMAND}\" returned empty version string"
    exit 1
fi

if [[ ${!DEPLOY_BASENAME[@]} ]]; then
  if [[ -n "${DEPLOY_BASENAME}" ]]; then
        if [[ -n "${VERSION}" ]]; then
            export DEPLOY_NAME="${DEPLOY_BASENAME}-${VERSION}${DEPLOY_EXT}"
            echo "Set DEPLOY_NAME to ${DEPLOY_NAME}"
        else
            echo "Not setting DEPLOY_NAME because VERSION is empty"
        fi
  else
    echo "Not setting DEPLOY_NAME because DEPLOY_BASENAME is empty"
  fi
fi
