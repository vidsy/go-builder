#!/bin/sh

INSTALL="${1:-true}"
BUILD="${2:-true}"
SETUP_SSH="${3:-false}"
USER=$(whoami)
SSH_KEY_NAME="id_circleci_github"

log () {
	echo "[go-builder] => $1" 
} 

if [ "$SETUP_SSH" == "true" ]; then
  log "Setting up SSH config for private repos"
  mkdir -p /$USER/.ssh
  echo -e "Host github.com\nIdentitiesOnly yes\nIdentityFile /$USER/.ssh/$SSH_KEY_NAME\nStrictHostKeyChecking no\nUserKnownHostsFile=/dev/null" > /$USER/.ssh/config
  chown -R $USER:$USER /$USER/.ssh
  chmod 700 /$USER/.ssh
  chmod 600 /$USER/.ssh/*
fi

if [ "$INSTALL" == "true" ]; then
  log "Installing dependencies with glide"
  glide install
fi

if [ "$BUILD" == "true" ]; then
  log "Building binary"
  CGO_ENABLED=0 go build -a -installsuffix nocgo .
fi
