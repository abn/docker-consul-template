FROM fedora:latest
MAINTAINER Arun Neelicattu <arun.neelicattu@gmail.com>

RUN dnf -y upgrade

# install base requirements
RUN dnf -y install golang git hg

# prepare gopath
ENV GOPATH /go
ENV PATH /go/bin:${PATH}
RUN mkdir -p ${GOPATH}

ENV PACKAGE github.com/hashicorp/consul-template
ENV VERSION 0.12.0
ENV GO_BUILD_TAGS netgo
ENV CGO_ENABLED 0

RUN go get ${PACKAGE}

WORKDIR ${GOPATH}/src/${PACKAGE}
RUN git checkout -b v${VERSION} v${VERSION}

RUN mkdir bin
RUN go build \
        -tags "${GO_BUILD_TAGS}" \
        -ldflags "-s -w -X ${PACKAGE}/version.Version ${VERSION}" \
        -v -a \
        -installsuffix cgo \
        -o ./bin/consul-template

RUN mkdir templates

ENV ROOTFS=./rootfs

RUN mkdir -p ${ROOTFS}
RUN mkdir -p ${ROOTFS}/usr/bin/ \
    ${ROOTFS}/etc/consul-template/{config.d,templates}
RUN mv ./bin/consul-template ${ROOTFS}/usr/bin/consul-template

# install sh for "command"
COPY ./loadbins /usr/bin/loadbins
ENV DEST ${ROOTFS}
RUN loadbins /usr/bin/sh
RUN loadbins /lib64/libpthread.so.0
RUN dnf -y install findutils
RUN install -D /usr/bin/sh ${ROOTFS}/bin/sh

COPY Dockerfile.final ./Dockerfile

CMD docker build -t alectolytic/consul-template ${PWD}
