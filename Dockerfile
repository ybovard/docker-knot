FROM easypi/alpine-arm:latest
MAINTAINER Yves Bovard <ybovard@gmail.com>

# Select entrypoint
WORKDIR /root
CMD ["/usr/local/sbin/knotd"]

# Expose port
EXPOSE 53

# Environment
ENV THREADS 1
ENV BUILD_PKGS git make gcc g++ libffi-dev pkgconf libtool autoconf automake userspace-rcu-dev bsd-compat-headers\
               userspace-rcu-dev lmdb-dev gnutls-dev jansson-dev libedit-dev libidn-dev libpcap-dev protobuf-c-dev file
ENV RUNTIME_PKGS userspace-rcu lmdb gnutls jansson libedit libidn libpcap protobuf-c

# Install dependencies and sources
RUN apk update && apk upgrade \
    && apk add ${BUILD_PKGS} ${RUNTIME_PKGS} && \
# Compile sources
git clone -b master https://gitlab.labs.nic.cz/knot/knot-dns.git /knot-src && \
cd /knot-src && \
git checkout tags/v2.5.3 && \
autoreconf -if && \
./configure --disable-static --enable-fastparser --disable-documentation && \
make -j${THREADS} && \
make install && \
###ldconfig && \
# Trim down the image
cd && \
rm -rf /knot-src && \
apk del ${BUILD_PKGS} && \
rm -rf /tmp/* /var/tmp/*
