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
BUILD_TIME="${BUILD_TIME:-$(date -u +"%d/%m/%YT%H:%M:%S%z")}"
BUILD_TIME_PACKAGE="${BUILD_TIME_PACKAGE:-main}"
BUILD_TIME_VARIABLE_NAME="${BUILD_TIME_VARIABLE_NAME:-BuildTime}"


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
  _log "Installing dependencies with glide"
  glide install
fi

if [ "${BUILD}" == "true" ]; then
  _log "Building binary"
  go build -ldflags "$VERSION_FLAGS" -a -installsuffix nocgo .
fi
