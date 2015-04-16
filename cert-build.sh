#!/bin/bash

ARGS="-o $1"
REG=${2:=localhost}

for SRV in $3 ; do
	ARGS="$ARGS -s $SRV"

done
export REGISTRY=$REG
echo "generating certs: $ARGS"
cert-tool $ARGS -d /tmp/docker-tls-certificates
cd /tmp
tar czf $HOME/rpmbuild/SOURCES/docker-tls-certificates.tar.gz docker-tls-certificates
cp -r /tmp/certs $HOME/rpmbuild/SOURCES/certs
rpmbuild -ba $HOME/rpmbuild/SPECS/docker-tls-certificates.spec
