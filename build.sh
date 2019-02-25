#!/bin/sh

# --
# Stop script if any command fails and run _cleanup() function.
# --

set -e

INSTALL="${INSTALL:-true}"
BUILD="${BUILD:-true}"
SETUP_SSH="${SETUP_SSH:-false}"
USER=$(whoami)
SSH_KEY_NAME="id_circleci_github"
VERSION_FLAGS=""
VERSION_PACKAGE="${VERSION_PACKAGE:-main}"
VERSION_VARIABLE_NAME="${VERSION_VARIABLE_NAME:-Version}"
BUILD_PATH="${BUILD_PATH:-.}"
BUILD_TIME="${BUILD_TIME:-$(date -u +"%d/%m/%YT%H:%M:%S%z")}"
BUILD_TIME_PACKAGE="${BUILD_TIME_PACKAGE:-main}"
BUILD_TIME_VARIABLE_NAME="${BUILD_TIME_VARIABLE_NAME:-BuildTime}"
OUTPUT_ZONEINFO="${OUTPUT_ZONEINFO:-false}"

_log () {
  echo "[go-builder] => $1"
}

if [ -f VERSION ]; then
	_log "Version file found, adds ld flags"
	VERSION_FLAGS="-X ${VERSION_PACKAGE}.${VERSION_VARIABLE_NAME}=$(cat VERSION) -X ${BUILD_TIME_PACKAGE}.${BUILD_TIME_VARIABLE_NAME}=${BUILD_TIME}"
fi

if [ "${SETUP_SSH}" == "true" ]; then
  _log "Setting up SSH config for private repos"
  mkdir -p /${USER}/.ssh
  echo -e "Host github.com\nIdentitiesOnly yes\nIdentityFile /${USER}/.ssh/${SSH_KEY_NAME}\nStrictHostKeyChecking no\nUserKnownHostsFile=/dev/null" > /${USER}/.ssh/config
  chown -R ${USER}:${USER} /${USER}/.ssh
  chmod 700 /${USER}/.ssh
  chmod 600 /${USER}/.ssh/*
fi

if [ "${INSTALL}" == "true" ]; then
  if [ -f glide.yaml ]; then
    _log "Warning - Glide is DEPRECATED, please use dep instead"
    _log "Installing dependencies with Glide"
    glide install
  elif [ -f Gopkg.toml ]; then
    _log "Installing dependencies with Dep"
    dep ensure
  else
    _log "Currently go-builder only supports the dependency manangers Glide and Dep"
    exit -1
  fi
fi

if [ "${BUILD}" == "true" ]; then
  _log "Building binary"
  go build -i -ldflags "$VERSION_FLAGS" -a -installsuffix nocgo ${BUILD_PATH}
fi

if [ "${OUTPUT_ZONEINFO}" == "true" ]; then
  _log "Copying /usr/local/go/lib/time/zoneinfo.zip to current directory"
  cp /usr/local/go/lib/time/zoneinfo.zip .
fi
