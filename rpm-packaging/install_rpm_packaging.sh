#!/usr/bin/bash

set -ex

yum install -y \
    bash \
    coreutils \
    diffutils \
    gcc \
    make \
    patch \
    rpm-build \
    rpm-devel \
    rpmdevtools
    rpmlint \
    tree

