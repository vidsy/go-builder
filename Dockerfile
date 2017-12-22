FROM golang:1.7.0-alpine
LABEL maintainer="Vidsy <tech@vidsy.co>"

ARG VERSION
LABEL version=$VERSION

ENV GLIDE_VERSION 0.12.3
ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/v$GLIDE_VERSION/glide-v$GLIDE_VERSION-linux-amd64.zip
ENV CGO_ENABLED 0

RUN apk update \
  && apk add openssh-client make git ca-certificates tar wget \
  && update-ca-certificates

RUN wget -O glide.zip "$GLIDE_DOWNLOAD_URL"
RUN unzip glide.zip linux-amd64/glide
RUN mv linux-amd64/glide /usr/local/bin
RUN rm -rf linux-amd64 glide.zip

ADD ./build.sh /scripts/build.sh

ENTRYPOINT ["/scripts/build.sh"]
