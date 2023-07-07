#!/bin/bash

set -euxo pipefail

if [ -z "$PACKAGE_NAME" ] || [ -z "$PACKAGE_VERSION" ]
then
    echo "[ERROR] Missing either \`PACKAGE_NAME\` or \`PACKAGE_VERSION\`"
    exit 1
fi

PKG="${PACKAGE_NAME}-${PACKAGE_VERSION}"
SOURCE_PKG="$PKG-1.el7.src.rpm"
BIN_PKG="$PKG-1.el7.x86_64.rpm"
TARBALL="${PACKAGE_NAME}_${PACKAGE_VERSION}.tar.gz"

RPMBUILD=/root/rpmbuild
SPEC="$RPMBUILD/SPECS/${PACKAGE_NAME}.spec"
BUILDDIRROOT="/root/build/${PACKAGE_NAME}/${PACKAGE_VERSION}"
BUILDDIR="$BUILDDIRROOT/$PKG"

cd /root

mkdir -p "$BUILDDIRROOT"
cd "$BUILDDIRROOT"

# The `curl` package downloaded from yum doesn't recognize the `--output-dir` option.
if ! curl --insecure \
    --location \
    --remote-name \
    "https://github.com/btoll/$PACKAGE_NAME/releases/download/$PACKAGE_VERSION/$TARBALL" 2> /dev/null
#    https://github.com/btoll/simple-chat/archive/refs/tags/1.0.0.tar.gz
then
    echo "[ERROR] Could not download $TARBALL."
    exit 1
fi

if ! tar -xvzf "$TARBALL" "$PKG/rpm/$PACKAGE_NAME.spec" -O 2> /dev/null > "$PACKAGE_NAME.spec"
then
    echo "[ERROR] Missing SPEC file."
    exit 1
fi

# Always remove previous package builds.
#
# Note that we don't want to remove the previous pacage build structure until after we're sure
# that we can download the new tarball.
rm -rf "$RPMBUILD"
rpmdev-setuptree

mv "$PACKAGE_NAME.spec" "$RPMBUILD/SPEC"
sed -i "s/NAME/$PACKAGE_NAME/g" "$SPEC"
sed -i "s/VERSION/$PACKAGE_VERSION/g" "$SPEC"
sed -i "s/SUMMARY/Holy zap/g" "$SPEC"
# The following lines go in the %changelog section.
echo "* Tue May 31 2016 Benjamin Toll <ben@benjamintoll.com> - ${PACKAGE_VERSION}-1" >> "$SPEC"
echo "- Initial release" >> "$SPEC"

mv "$TARBALL" "$RPMBUILD/SOURCES"

rpmbuild -bs "$SPEC"
rpmbuild -bb "$SPEC"

mkdir -p "$BUILDDIR"
cp "$RPMBUILD/RPMS/x86_64/$BIN_PKG" \
    "$RPMBUILD/SRPMS/$SOURCE_PKG" \
    "$RPMBUILD/SOURCES/$TARBALL" \
    "$BUILDDIR"

chown -R "$USER":"$USER" /root/build

