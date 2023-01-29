#!/bin/bash

set -euo pipefail

if [ "$EUID" -ne 0 ]
then
    echo "[ERROR] This script must be run as root!" 1>&2
    exit 1
fi

useradd \
    --create-home \
    --home-dir /home/noroot \
    noroot

apt-get update && apt-get install -y \
    git \
    nodejs \
    npm \
    python3 \
    python3-pip

cd /home/noroot
git clone https://github.com/btoll/music-theory.git
cd music-theory
npm install
npm run build

