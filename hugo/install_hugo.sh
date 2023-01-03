#!/bin/bash

set -euo pipefail

if [ "$EUID" -ne 0 ]
then
    echo "[ERROR] This script must be run as root!" 1>&2
    exit 1
fi

VERSION=0.80.0

apt-get update && apt-get install -y \
    git \
    wget

wget -O - "https://github.com/gohugoio/hugo/releases/download/v$VERSION/hugo_${VERSION}_Linux-64bit.tar.gz" \
    | tar -xz -C /usr/bin

mkdir /themes
git clone https://github.com/niklasbuschmann/contrast-hugo.git /themes/contrast-hugo
git clone https://github.com/jrutheiser/hugo-lithium-theme.git /themes/hugo-lithium-theme

