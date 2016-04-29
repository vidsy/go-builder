#!/bin/bash

glide install
GO15VENDOREXPERIMENT=1 CGO_ENABLED=0 go build -a -installsuffix nocgo .
