FROM alpine:3.9 as dependencies

ENV GLIDE_VERSION 0.13.2
ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/v$GLIDE_VERSION/glide-v$GLIDE_VERSION-linux-amd64.zip

ENV DEP_VERSION 0.5.2
ENV DEP_DOWNLOAD_URL https://github.com/golang/dep/releases/download/$DEP_VERSION/dep-linux-amd64

ENV GO_RELEASER_VERSION 0.106.0
ENV GO_RELEASER_DOWNLOAD_URL https://github.com/goreleaser/goreleaser/releases/download/v$GO_RELEASER_VERSION/goreleaser_Linux_x86_64.tar.gz

RUN apk update \
  && apk add --no-cache openssh-client make git ca-certificates tar curl \
  && update-ca-certificates

RUN curl -L -o glide.zip "$GLIDE_DOWNLOAD_URL"
RUN unzip glide.zip linux-amd64/glide
RUN mv linux-amd64/glide /usr/local/bin
RUN rm -rf linux-amd64 glide.zip

RUN curl -L -o /usr/local/bin/dep "$DEP_DOWNLOAD_URL"

RUN curl -L -o goreleaser_Linux_x86_64.tar.gz "$GO_RELEASER_DOWNLOAD_URL"
RUN tar -xf goreleaser_Linux_x86_64.tar.gz
RUN mv goreleaser /usr/local/bin/goreleaser

FROM golang:1.12.5-alpine3.9
LABEL maintainer="Vidsy <tech@vidsy.co>"

ARG VERSION
LABEL version=$VERSION

ENV CGO_ENABLED 0
ENV GOCACHE /go/pkg/cache

RUN apk update \
  && apk add --no-cache openssh-client make git ca-certificates tar gcc \
  && update-ca-certificates

COPY --from=dependencies /usr/local/bin/glide /usr/local/bin/glide
COPY --from=dependencies /usr/local/bin/dep /usr/local/bin/dep
COPY --from=dependencies /usr/local/bin/goreleaser /usr/local/bin/goreleaser

RUN chmod u+x /usr/local/bin/dep
RUN chmod u+x /usr/local/bin/goreleaser

ADD ./build.sh /scripts/build.sh

ENTRYPOINT ["/scripts/build.sh"]
