#!/bin/sh

set -e

USER=$(whoami)
INSTALL="${INSTALL:-true}"
BUILD="${BUILD:-true}"
BUILD_PATH="${BUILD_PATH:-.}"

VERSION=$(cat VERSION)
BUILD_TIME=$(date -u +"%d/%m/%YT%H:%M:%S%z")

LDFLAGS=""

for arg in "$@"
do
    case $arg in
		-v=*|--version=*)
        VERSION="${arg#*=}"
        shift
        ;;
		-t=*|--build-time=*)
        BUILD_TIME="${arg#*=}"
        shift
        ;;
		--ldflag=*)
        LDFLAGS="${LDFLAGS}${arg#*=} "
        shift
        ;;
    esac
done

VERSION_PACKAGE="${VERSION_PACKAGE:-main}"
VERSION_VARIABLE_NAME="${VERSION_VARIABLE_NAME:-Version}"
VERSION_LDFLAG="-X ${VERSION_PACKAGE}.${VERSION_VARIABLE_NAME}"

BUILD_TIME_PACKAGE="${BUILD_TIME_PACKAGE:-main}"
BUILD_TIME_VARIABLE_NAME="${BUILD_TIME_VARIABLE_NAME:-BuildTime}"
BUILD_TIME_LDFLAG="-X ${BUILD_TIME_PACKAGE}.${BUILD_TIME_VARIABLE_NAME}"

OUTPUT_ZONEINFO="${OUTPUT_ZONEINFO:-false}"

_log () {
  echo "[go-builder] => $1"
}

if [ -f VERSION ]; then
	_log "Version file found, adds ld flags"

	for FLAG in "${VERSION_LDFLAG}=${VERSION}" \
				"${BUILD_TIME_LDFLAG}=${BUILD_TIME}"
		do
		LDFLAGS="${LDFLAGS}${FLAG} "
 	done
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

LDFLAGS=${LDFLAGS} | sed 's/ *$//g'

_log "LDFLAGS=${LDFLAGS}"

if [ "${BUILD}" == "true" ]; then
  _log "Building binary"
  go build -i -ldflags "$LDFLAGS" -a -installsuffix nocgo ${BUILD_PATH}
fi

if [ "${OUTPUT_ZONEINFO}" == "true" ]; then
  _log "Copying /usr/local/go/lib/time/zoneinfo.zip to current directory"
  cp /usr/local/go/lib/time/zoneinfo.zip .
fi
