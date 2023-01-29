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
PrivateUsers=true
ProcessTwo=true
ResolvConf=copy-host
Timezone=copy
WorkingDirectory=/home/noroot/scale_buddy
User=noroot
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

```
$ sudo systemd-nspawn --quiet --machine scale-buddy scale_buddy g
G major:
G  A  B  C  D  E  F♯
```

You could always create an alias to simplify things a bit:

```
$ alias sb="sudo systemd-nspawn --quiet --machine scale-buddy scale_buddy"
$ sb g --with-minor
G major:
G  A  B  C  D  E  F♯

G natural minor (Aeolian):
G  A  B♭  C  D  E♭  F

G harmonic minor:
G  A  B♭  C  D  E♭  F♯

G melodic minor (jazz minor):
G  A  B♭  C  D  E  F♯
```
[`btoll/scale-buddy` on Docker Hub]: https://hub.docker.com/r/btoll/scale-buddy

