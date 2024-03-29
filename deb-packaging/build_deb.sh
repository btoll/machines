#!/bin/bash

set -euxo pipefail

trap cleanup EXIT

cleanup() {
    rm -rf /root/build
}

#. "$HOME/.bashrc"
#
#GOBIN="$HOME/go/bin"

DEB_BIN="${PACKAGE_NAME}_${PACKAGE_VERSION}_amd64.deb"
DEB_SRC="${PACKAGE_NAME}_${PACKAGE_VERSION}.dsc"
TARBALL="${PACKAGE_NAME}_${PACKAGE_VERSION}.tar.gz"

BUILDDIRROOT="/build/${PACKAGE_NAME}/${PACKAGE_VERSION}"
BUILDDIR="$BUILDDIRROOT/${PACKAGE_NAME}-${PACKAGE_VERSION}"

# We'll clone into this directory, but the packages will be
# placed in its parent (/build) went built.
WORKDIR="/root/build/${PACKAGE_NAME}-${PACKAGE_VERSION}"

# `git-clone` will create the nested directory structure.
if [ -n "$LOCAL" ] && [ "$LOCAL" = 1 ]
then
    echo "[INFO] Cloning local git repository bind-mounted at /clone."
    git clone /clone "$WORKDIR"
else
    echo "[INFO] Cloning remote git repository."
    git clone "https://github.com/btoll/$PACKAGE_NAME.git" "$WORKDIR"
fi

cd "$WORKDIR"

#if [ -f go.mod ]
#then
#    mkdir -p "$HOME/bin"
#    GO_VERSION=$(sed -rn 's/^go ([0-9]\.[0-9]{1,2}\.?[0-9]{1,2})/\1/p' go.mod)
#    if ! command -v "go$GO_VERSION"
#    then
#        go get "golang.org/dl/go$GO_VERSION@latest"
#        "$GOBIN/go$GO_VERSION" download
#        "$GOBIN/go$GO_VERSION" version
#        "$GOBIN/go$GO_VERSION" env
#    fi
#fi

# The following will get the long id from the list of secret keys.
# Specifically, the `sed` command will parse this:
#
#   ssb   rsa4096/3A1314344B0D9912 2023-06-04 [S]
#
KEYID=$(gpg \
    --list-secret-keys \
    --keyid-format=long \
    Debian \
    | grep "\[S\]" \
    | sed -n 's/.*rsa[0-9]*\/\([A-Z0-9]*\).*/\1/p')

# Build both the binary and source packages and sign both.
# This signs the `InRelease` file and creates a detached signature in the binary package.
# This signs the `.dsc` and `.changes` files of the source package.
dpkg-buildpackage \
	--build=source,any,all \
    --check-builddeps \
	--force-sign \
    --post-clean \
	--root-command=fakeroot \
	--sign-key="$KEYID"

# Sign and let end-user decide if they want to verify using `debsig-verify` the `_deborigin`
# file that `debsigs` puts in the `.deb` package.
debsigs --sign=origin -k "$KEYID" "../$DEB_BIN"

# Don't keep these package build assets:
# - asbits-dbgsym_1.0.0_amd64.deb
# - asbits_1.0.0_amd64.buildinfo
# - asbits_1.0.0_amd64.changes

# Since `systemd` is watching the build dir, don't create it until the last possible moment.
mkdir -p "$BUILDDIR"
mv "/root/build/$DEB_BIN" "$BUILDDIR"
mv "/root/build/$DEB_SRC" "$BUILDDIR"
mv "/root/build/$TARBALL" "$BUILDDIR"

ls -l "$BUILDDIR"

chown -R "$USER":"$USER" /build

