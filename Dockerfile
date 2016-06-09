FROM smebberson/alpine-base:3.0.0

MAINTAINER Deepak Prabhakara <deepak.prabhakara@gmail.com> (@deepakprab)

ENV version="1.10"

COPY root /

RUN apk --update add --virtual build-dependencies \
  gcc \
  make \
  musl-dev \
  curl \
  && curl -sL https://github.com/kr/beanstalkd/archive/v$version.tar.gz | tar xvz -C /tmp \
  && cd /tmp/beanstalkd-$version \
  && sed -i "s|#include <sys/fcntl.h>|#include <fcntl.h>|g" sd-daemon.c \
  && make \
  && cp beanstalkd /usr/bin \
  && apk del build-dependencies \
  && apk del curl \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/*

EXPOSE 11300
