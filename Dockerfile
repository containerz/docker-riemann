FROM frolvlad/alpine-oraclejdk8
ENV RIEMANN_VERSION 0.2.10
RUN apk --update add wget \
                     ca-certificates \
                     tar \
    && wget -O /tmp/riemann.tar.bz2 https://aphyr.com/riemann/riemann-${RIEMANN_VERSION}.tar.bz2 \
    && mkdir /opt \
    && tar -xvjf /tmp/riemann.tar.bz2 -C /opt \
    && rm /tmp/riemann.tar.bz2 \
    && sed -i'' -e 's/env bash/env sh/' /opt/riemann-${RIEMANN_VERSION}/bin/riemann \
    && sed -i'' -e 's/127.0.0.1/0.0.0.0/' /opt/riemann-${RIEMANN_VERSION}/etc/riemann \
    && apk del wget \
               ca-certificates \
               tar \
    && rm -rf /var/cache/apk/*
EXPOSE 5555/tcp 5555/udp 5556
WORKDIR /opt/riemann-${RIEMANN_VERSION}
ENTRYPOINT ["bin/riemann", "etc/riemann.config"]
