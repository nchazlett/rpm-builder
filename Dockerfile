FROM fedora:latest

MAINTAINER Nick Hazlett <nchazlett@gmail.com>

RUN yum -y update
RUN yum install -y rpm-build
RUN yum install -y fedora-packager
RUN yum install -y vim 

RUN useradd makerpm
RUN chown -R makerpm:makerpm /home/makerpm

WORKDIR /home/makerpm

ENV HOME /home/makerpm

USER makerpm
RUN rpmdev-setuptree

ADD https://github.com/ehazlett/cert-tool/releases/download/v0.0.1/cert-tool_linux_amd64 /bin/cert-tool
ADD https://github.com/nchazlett/dockerfiles/blob/master/README.md README.md

CMD /bin/bash

