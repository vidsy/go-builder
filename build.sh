#!/bin/sh

glide install
CGO_ENABLED=0 go build -a -installsuffix nocgo .
