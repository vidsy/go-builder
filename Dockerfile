FROM golang:1.12.5-alpine3.9
LABEL maintainer="Vidsy <tech@vidsy.co>"

ARG VERSION
LABEL version=$VERSION

ENV GLIDE_VERSION 0.13.2
ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/v$GLIDE_VERSION/glide-v$GLIDE_VERSION-linux-amd64.zip

ENV DEP_VERSION 0.5.1
ENV DEP_DOWNLOAD_URL https://github.com/golang/dep/releases/download/v$DEP_VERSION/dep-linux-amd64

ENV GO_RELEASER_VERSION 0.106.0
ENV GO_RELEASER_DOWNLOAD_URL https://github.com/goreleaser/goreleaser/releases/download/v$GO_RELEASER_VERSION/goreleaser_Linux_x86_64.tar.gz

ENV CGO_ENABLED 0

RUN apk update \
  && apk add openssh-client make git ca-certificates tar wget \
  && update-ca-certificates

RUN wget -q -O glide.zip "$GLIDE_DOWNLOAD_URL"
RUN unzip glide.zip linux-amd64/glide
RUN mv linux-amd64/glide /usr/local/bin
RUN rm -rf linux-amd64 glide.zip

RUN wget -q -O /usr/local/bin/dep "$DEP_DOWNLOAD_URL"
RUN chmod u+x /usr/local/bin/dep

RUN wget -q -O goreleaser_Linux_x86_64.tar.gz "$GO_RELEASER_DOWNLOAD_URL"
RUN tar -xf goreleaser_Linux_x86_64.tar.gz
RUN mv goreleaser /usr/local/bin/goreleaser
RUN chmod u+x /usr/local/bin/goreleaser

ADD ./build.sh /scripts/build.sh

ENTRYPOINT ["/scripts/build.sh"]
