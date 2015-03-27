FROM fedora:latest

MAINTAINER Nick Hazlett <nchazlett@gmail.com>

RUN yum -y update
RUN yum install -y rpm-build
RUN yum install -y fedora-packager

RUN useradd makerpm
RUN chown -R makerpm:makerpm /home/makerpm

WORKDIR /home/makerpm

ENV HOME /home/makerpm

USER makerpm
RUN rpmdev-setuptree

CMD /bin/bash

