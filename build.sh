#!/bin/sh

set -e

INSTALL="${INSTALL:-true}"
BUILD="${BUILD:-true}"
USER=$(whoami)
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

if [ "${INSTALL}" == "true" ]; then
  if [ -f go.mod ]; then
    _log "Installing dependencies using Go Modules"
    go mod download
  else
    _log "Currently go-builder only supports Go Modules for dependency mangagment"
    exit 1
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
