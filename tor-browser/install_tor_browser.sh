#!/bin/bash
#shellcheck disable=2015

trap cleanup EXIT

cleanup() {
    rm -rf tor-browser* "$GNUPGHOME" "$HOME/.gnupg"
}

USER=noroot
BINDIR=/usr/local/bin/tor-browser
TOR_VERSION=12.0.1
LANG=C.UTF-8
TOR_FINGERPRINT=0x4E2C6E8793298290
TOR_DOWNLOAD="tor-browser-linux64-${TOR_VERSION}_ALL.tar.xz"
TOR_SIG_FILE="$TOR_DOWNLOAD.asc"
TOR_URL="https://dist.torproject.org/torbrowser/$TOR_VERSION"

HOME="/home/$USER"
useradd --create-home --home-dir "$HOME" "$USER" \
	&& chown -R "$USER:$USER" "$HOME"

apt-get update && apt-get install -y \
    gnupg \
    wget \
	xz-utils \
	libasound2 \
	libdbus-glib-1-2 \
	libgtk-3-0 \
	libx11-xcb-dev \
	libx11-xcb1 \
	libxrender1 \
	libxt6

mkdir "$BINDIR"

wget "$TOR_URL/$TOR_DOWNLOAD"
wget "$TOR_URL/$TOR_SIG_FILE"

GNUPGHOME="$(mktemp -d)"
for server in $(shuf -e \
    ha.pool.sks-keyservers.net \
    hkp://p80.pool.sks-keyservers.net:80 \
    keyserver.ubuntu.com \
    hkp://keyserver.ubuntu.com:80 \
    pgp.mit.edu)
do
    gpg --no-tty --keyserver "$server" --recv-keys "$TOR_FINGERPRINT" && break || : ;
done

gpg --fingerprint --keyid-format LONG "$TOR_FINGERPRINT" \
    | grep "Key fingerprint = EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290"
gpg --verify "$TOR_SIG_FILE"

tar xJ --strip-components 2 --directory "$BINDIR" -f "$TOR_DOWNLOAD"
chown -R "$USER:$USER" "$BINDIR"

