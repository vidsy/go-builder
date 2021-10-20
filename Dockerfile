FROM alpine:3.11 as dependencies

ENV GO_RELEASER_VERSION 0.106.0
ENV GO_RELEASER_DOWNLOAD_URL https://github.com/goreleaser/goreleaser/releases/download/v$GO_RELEASER_VERSION/goreleaser_Linux_x86_64.tar.gz

RUN apk update \
  && apk add --no-cache openssh-client make git ca-certificates tar curl \
  && update-ca-certificates

RUN curl -L -o goreleaser_Linux_x86_64.tar.gz "$GO_RELEASER_DOWNLOAD_URL"
RUN tar -xf goreleaser_Linux_x86_64.tar.gz
RUN mv goreleaser /usr/local/bin/goreleaser

FROM golang:1.17.2-alpine3.14
LABEL maintainer="Vidsy <tech@vidsy.co>"

ARG VERSION
LABEL version=$VERSION

ENV CGO_ENABLED 0
ENV GOCACHE /go/pkg/cache
ENV GOPRIVATE github.com/vidsy/*

RUN apk update \
  && apk add --no-cache openssh-client make git ca-certificates tar gcc \
  && update-ca-certificates

COPY --from=dependencies /usr/local/bin/goreleaser /usr/local/bin/goreleaser

RUN chmod u+x /usr/local/bin/goreleaser

ADD ./build.sh /scripts/build.sh

ENTRYPOINT ["/scripts/build.sh"]
