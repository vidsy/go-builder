FROM golang:1.6.2
MAINTAINER charlie@vidsy.co

ENV GLIDE_VERSION 0.10.2
ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/$GLIDE_VERSION/glide-$GLIDE_VERSION-linux-amd64.zip

ADD ./build.sh /scripts/build.sh

ENTRYPOINT ["/scripts/build.sh"]

RUN apt-get update \
  && apt-get install -y unzip --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && curl -fsSL "$GLIDE_DOWNLOAD_URL" -o glide.zip \
  && unzip glide.zip  linux-amd64/glide \
  && mv linux-amd64/glide /usr/local/bin \
  && rm -rf linux-amd64 \
  && rm glide.zip
