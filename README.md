# Description
use this dockerfile to create a docker image of knot-dns for Raspberry Pi 2. One tag is made pro knot-dns release

# Usage
docker run -t --name knot -p 53:53/tcp -p 53:53/udp -v /data/knot.conf:/usr/local/etc/knot/knot.conf ybovard/knot
