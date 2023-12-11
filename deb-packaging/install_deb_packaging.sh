#!/usr/bin/bash

set -euxo pipefail

apt-get update
apt-get install -y \
    curl \
    debsigs \
    devscripts \
    dh-make \
    gnupg \
    openssh-server
#    golang-any \
#    dh-golang \

#locale-gen en_US.UTF-8
#localectl set-locale LANG=en_US.UTF-8

# Download and install Go.
curl -L https://go.dev/dl/go1.20.6.linux-amd64.tar.gz | tar -xz -C /usr/local/
install -m 0755 /usr/local/go/bin/* /usr/local/bin
#export PATH="/usr/local/go/bin:$PATH"
#echo -e "GOPATH=$HOME/go\nGOBIN=$HOME/go/bin\nPATH=$HOME/go/bin:$PATH" >> "$HOME/.bashrc"

echo "StreamLocalBindUnlink yes" >> /etc/ssh/sshd_config
/etc/init.d/ssh start

# If the .gnupg dir doesn't have the correct permissions, the key can't be imported.
# Should be either 0600 or 0700.
curl -LO https://github.com/btoll/keyserver/blob/master/benjamintoll.key
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

