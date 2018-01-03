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
               userspace-rcu-dev lmdb-dev gnutls-dev jansson-dev libedit-dev libidn-dev libpcap-dev protobuf-c-dev file libevent-dev
ENV RUNTIME_PKGS userspace-rcu lmdb gnutls jansson libedit libidn libpcap protobuf-c libevent

# Install dependencies and sources
RUN apk update && apk upgrade \
    && apk add ${BUILD_PKGS} ${RUNTIME_PKGS} && \
# Fix bash bug (ok since version bash-4.4.12-r2)
export CONFIG_SHELL=/bin/sh &&\
# Compile+install fstrm sources
cd &&\
git clone https://github.com/farsightsec/fstrm.git &&\
cd fstrm &&\
./autogen.sh && ./configure && make && make check && make install &&\
# Compile+install knot sources
cd &&\
git clone https://gitlab.labs.nic.cz/knot/knot-dns.git && \
cd knot-dns && \
git checkout tags/v2.6.4 && \
autoreconf -if && \
./configure --disable-static --enable-fastparser --disable-documentation && \
make -j${THREADS} && \
make install && \
###ldconfig && \
# Trim down the image
cd && \
rm -rf knot-dns && \
rm -rf fstrm && \
apk del ${BUILD_PKGS} && \
rm -rf /tmp/* /var/tmp/*
