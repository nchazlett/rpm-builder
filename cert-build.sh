#!/bin/bash

ARGS="-o $1"
REG=${2:=localhost}
SERVERS=${3:-localhost}

for SRV in $SERVERS ; do
	ARGS="$ARGS -s $SRV"
done

export REGISTRY=$REG

cat << EOF > $HOME/rpmbuild/SPECS/docker-tls-certificates.spec
Summary:        Docker TLS Certificates
Name:           docker-tls-certificates
Version:        1.0
Release:        0
# License is a compulsory field so you have to put something there.
License:        none
Source:         %{name}.tar.gz
# This package doesn't contain any binary files so it's architecture independent, hence
# specify noarch for the BuildArch.
BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-build
# I don't worry too much about the group since now one uses the rpm except me
# There's a list at /usr/share/doc/packages/rpm/GROUPS but you don't have to use one of them
# I just use System/Base by default and only change it if something more suitable occurs to me
Group:          System/Base
Vendor:         Docker Cert Build

%description
This package provides my cert builder scripts.

%prep
# the set up macro unpacks the source bundle and changes in to the represented by
# %{name} which in this case would be my_maintenance_scripts. So your source bundle
# needs to have a top level directory inside called my_maintenance _scripts
%setup -n %{name}

%build
# this section is empty for this example as we're not actually building anything

%install
# create directories where the files will be located
mkdir -p \$RPM_BUILD_ROOT/etc/docker/certs.d/$REGISTRY

# put the files in to the relevant directories.
# the argument on -m is the permissions expressed as octal. (See chmod man page for details.)
install -m 700 ca.pem \$RPM_BUILD_ROOT/etc/docker/certs.d/$REGISTRY/ca.pem
install -m 700 client.pem \$RPM_BUILD_ROOT/etc/docker/certs.d/$REGISTRY/client.pem
install -m 700 client-key.pem \$RPM_BUILD_ROOT/etc/docker/certs.d/$REGISTRY/client-key.pem
install -m 700 server.pem \$RPM_BUILD_ROOT/etc/docker/certs.d/$REGISTRY/server.pem
install -m 700 server-key.pem \$RPM_BUILD_ROOT/etc/docker/certs.d/$REGISTRY/server-key.pem

%post
# the post section is where you can run commands after the rpm is installed.


%clean
rm -rf \$RPM_BUILD_ROOT
rm -rf %{_tmppath}/%{name}
rm -rf %{_topdir}/BUILD/%{name}

# list files owned by the package here
%files
%defattr(-,root,root)
/etc/docker/certs.d
/etc/docker/certs.d/$REGISTRY/ca.pem
/etc/docker/certs.d/$REGISTRY/client.pem
/etc/docker/certs.d/$REGISTRY/client-key.pem
/etc/docker/certs.d/$REGISTRY/server.pem
/etc/docker/certs.d/$REGISTRY/server-key.pem

%changelog
* Thu Apr 16 2015  Nick Hazlett
- 1.0 r1 First release
EOF

echo "generating certs: $ARGS"

cert-tool $ARGS -d /tmp/certs

pushd /tmp > /dev/null
tar czf $HOME/rpmbuild/SOURCES/docker-tls-certificates.tar.gz docker-tls-certificates
popd /tmp > /dev/null

cp -r /tmp/certs $HOME/rpmbuild/SOURCES/certs

rpmbuild -ba $HOME/rpmbuild/SPECS/docker-tls-certificates.spec

mkdir -p /build
cp -r $HOME/rpmbuild/RPMS/noarch/* /build/
