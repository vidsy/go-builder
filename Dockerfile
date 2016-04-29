FROM golang:1.6.2
MAINTAINER charlie@vidsy.co

ENV GLIDE_VERSION 0.10.2
ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/$GLIDE_VERSION/glide-$GLIDE_VERSION-linux-amd64.zip

RUN apt-get update \
  && apt-get install -y unzip --no-install-recommends 

RUN curl -fsSL "$GLIDE_DOWNLOAD_URL" -o glide.zip \
  && unzip glide.zip  linux-amd64/glide \
  && mv linux-amd64/glide /usr/local/bin

RUN mkdir /scripts

ADD ./build.sh /scripts

ENTRYPOINT ["/scripts/build.sh"]
