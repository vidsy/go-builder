FROM golang:1.7.0-alpine
MAINTAINER charlie@vidsy.co

ENV GLIDE_VERSION 0.10.2
ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/$GLIDE_VERSION/glide-$GLIDE_VERSION-linux-amd64.zip

RUN apk update \
  && apk add openssh-client make git ca-certificates wget \
  && update-ca-certificates

RUN wget -O glide.zip "$GLIDE_DOWNLOAD_URL"
RUN unzip glide.zip linux-amd64/glide
RUN mv linux-amd64/glide /usr/local/bin
RUN rm -rf linux-amd64 glide.zip

ADD ./build.sh /scripts/build.sh

ENTRYPOINT ["/scripts/build.sh"]
