# Description
use this dockerfile to create a docker image of knot-dns for Raspberry Pi 2. The master version (tag latest) is for the last release of knot-dns. Currently v2.6.3

# Usage
docker run -t --name knot -p 53:53/tcp -p 53:53/udp -v /data/knot.conf:/usr/local/etc/knot/knot.conf ybovard/docker-knot
