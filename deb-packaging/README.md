# deb Packaging

Create and sign `deb` binary and source packages.

## Installing

### `systemd-nspawn`

#### Create the service

> If this is the first config, you may have to create the `/etc/systemd/nspawn/` directory.

`/etc/systemd/nspawn/deb-packaging.nspawn`

```
[Exec]
DropCapability=\
	CAP_NET_ADMIN \
	CAP_SETUID \
	CAP_SYS_ADMIN \
	CAP_SYS_CHROOT \
	CAP_SYS_RAWIO \
	CAP_SYSLOG
Environment=USER=1000
Hostname=kilgore-trout
NoNewPrivileges=true
Parameters=/build_deb.sh
PrivateUsers=true
ProcessTwo=true
ResolvConf=copy-host
Timezone=copy

[Files]
Bind=/home/btoll/build:/root/build
Bind=/run/user/1000/gnupg/S.gpg-agent:/root/.gnupg/S.gpg-agent
```

#### Get the Root Filesystem

#### Using `systemd-nspawn`

```
$ su -
# apt-get install debootstrap
# cd /var/lib/machines
# mkdir deb-packaging
# debootstrap \
    --arch=amd64 \
    --variant=minbase \
    bullseye deb-packaging http://deb.debian.org/debian
# cp /path/to/machines/deb-packaging/{install_deb_packaging,build_deb}.sh deb-packaging
# chroot deb-packaging
# ./install_deb_packaging.sh
# exit
# exit
```

## Examples

### Building and Signing

```
$ sudo systemd-nspawn \
    --machine deb-packaging \
    --setenv PACKAGE_NAME=asbits \
    --setenv PACKAGE_VERSION=1.0.0 \
    --setenv USER=1000 \
    --quiet
```

> Change `--setenv USER=1000` to your user ID, otherwise it will default to `root`, which may not be what you want.

