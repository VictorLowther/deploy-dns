FROM digitalrebar/base
MAINTAINER Victor Lowther <victor@rackn.com>

# Set our command
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

# Get packages
RUN apt-get update \
  && apt-get -y install bind9 bind9utils dnsutils \
  && /usr/local/go/bin/go get -v github.com/rackn/rebar-dns-mgmt \
  && mkdir -p /etc/dns-mgmt.d \
  && mkdir -p /var/cache/rebar-dns-mgmt \
  && chmod 700 /var/cache/rebar-dns-mgmt \
  && cp -r $GOPATH/src/github.com/rackn/rebar-dns-mgmt/*.tmpl /etc/dns-mgmt.d \
  && cp $GOPATH/bin/rebar-dns-mgmt /usr/local/bin/rebar-dns-mgmt

COPY bind /etc/bind
COPY dns.json /etc/consul.d/dns.json
COPY dns-mgmt.json /etc/consul.d/dns-mgmt.json
COPY dns-mgmt.conf /etc/dns-mgmt.conf
COPY database.json /var/cache/rebar-dns-mgmt/database.json
COPY dns-mgmt-cert.conf /etc/dns-mgmt-cert.conf
COPY entrypoint.d/*.sh /usr/local/entrypoint.d/
