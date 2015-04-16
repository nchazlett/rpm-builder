FROM fedora:latest

MAINTAINER Nick Hazlett <nchazlett@gmail.com>

RUN yum -y update
RUN yum install -y rpm-build
RUN yum install -y fedora-packager
RUN yum install -y vim 

#RUN useradd makerpm
#RUN chown -R makerpm:makerpm /home/makerpm

#WORKDIR /home/makerpm

#ENV HOME /home/makerpm

RUN curl -sSL https://github.com/ehazlett/cert-tool/releases/download/v0.0.2/cert-tool_linux_amd64 > /usr/local/bin/cert-tool && chmod +x /usr/local/bin/cert-tool
ADD cert-build.sh /usr/local/bin/cert-build.sh

#USER makerpm
RUN rpmdev-setuptree

ADD docker-tls-certificates.spec /root/rpmbuild/SPECS/

ENTRYPOINT ["/usr/local/bin/cert-build.sh"]

CMD /bin/bash

