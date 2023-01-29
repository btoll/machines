# `scale-buddy`

## Installing

### `systemd-nspawn`

#### Create the service

> If this is the first config, you may have to create the `/etc/systemd/nspawn/` directory.

`/etc/systemd/nspawn/scale-buddy.nspawn`

```
[Exec]
DropCapability=all
Hostname=kilgore-trout
NoNewPrivileges=true
#Parameters=pip3 install --editable .
Parameters=scale_buddy
PrivateUsers=true
ProcessTwo=true
ResolvConf=copy-host
Timezone=copy
WorkingDirectory=/home/noroot
```

#### Get the root filesystem

```
$ sudo -s
# apt-get install debootstrap
# cd /var/lib/machines
# mkdir scale-buddy
# debootstrap \
    --arch=amd64 \
    --variant=minbase \
    bullseye scale-buddy http://deb.debian.org/debian
# cp /path/to/machines/scale-buddy/install_scale_buddy.sh scale-buddy
# chroot scale-buddy
# ./install_scale_buddy.sh
# exit
# exit
```

### Docker

```
$ docker pull btoll/scale-buddy:beta
```

[`btoll/scale-buddy` on Docker Hub]

#### Get the root filesystem

As root:

```
# cd /var/lib/machines
# mkdir scale-buddy
# docker export $(docker create btoll/scale-buddy:beta) | tar -x -C scale-buddy
```

## Examples

[`btoll/scale-buddy` on Docker Hub]: https://hub.docker.com/r/btoll/scale-buddy

