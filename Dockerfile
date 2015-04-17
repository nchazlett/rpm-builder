FROM fedora:latest

MAINTAINER Nick Hazlett <nchazlett@gmail.com>

RUN yum -y update
RUN yum install -y rpm-build
RUN yum install -y fedora-packager
RUN yum install -y vim

RUN curl -sSL https://github.com/ehazlett/cert-tool/releases/download/v0.0.2/cert-tool_linux_amd64 > /usr/local/bin/cert-tool && chmod +x /usr/local/bin/cert-tool
ADD cert-build.sh /usr/local/bin/cert-build.sh

RUN rpmdev-setuptree

ENTRYPOINT ["/usr/local/bin/cert-build.sh"]

CMD /bin/bash
