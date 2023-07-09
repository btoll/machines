#!/usr/bin/bash

set -euxo pipefail

apt-get update
apt-get install -y \
    debsigs \
    devscripts \
    dh-golang \
    dh-make \
    golang-any \
    gnupg \
    openssh-server

#locale-gen en_US.UTF-8
#localectl set-locale LANG=en_US.UTF-8

echo "StreamLocalBindUnlink yes" >> /etc/ssh/sshd_config
/etc/init.d/ssh start

# If the .gnupg dir doesn't have the correct permissions, the key can't be imported.
# Should be either 0600 or 0700.
curl -LO https://github.com/btoll/gpg-agent-forwarding/raw/master/public.key
gpg --import public.key

KEYID=$(gpg \
    --show-keys \
    --keyid-format=long \
    public.key \
    | grep "\[S\]" \
    | sed -n 's/.*rsa[0-9]*\/\([A-Z0-9]*\).*/\1/p')

# Create the directories and copy in the public key that the `debsigs` tool needs.
mkdir -p "/usr/share/debsig/keyrings/$KEYID/"
cp /public.key "/usr/share/debsig/keyrings/$KEYID/debsig.gpg"

