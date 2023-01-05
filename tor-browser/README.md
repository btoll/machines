# tor-browser

> The `Dockerfile `uses Jessie Frazelle's [`tor-browser` Dockerfile](https://github.com/jessfraz/dockerfiles/tree/master/tor-browser) as for many of its bits.  There were enough changes to warrant its own Dockerfile.
>
> However, if you don't want to use Docker, then you're in luck!  The `install_tor_browser.sh` shell script is your friend, and it's a faithful recreation of what the `Dockerfile` is doing.
>
> For information on how to use it, read the ground-breaking article on `systemd-nspawn`, [On Running systemd-nspawn Containers].  Specifically, see the following [examples]:
>
> - [`debootstrap`](https://benjamintoll.com/2022/02/04/on-running-systemd-nspawn-containers/#debootstrap)
> - [`mkosi`](https://benjamintoll.com/2022/02/04/on-running-systemd-nspawn-containers/#mkosi)

## `systemd-nspawn`

### Create the service

> If this is the first config, you may have to create the `/etc/systemd/nspawn/` directory.

`/etc/systemd/nspawn/tor-browser.nspawn`

```
[Exec]
DropCapability=all
Environment=DISPLAY=:0
Hostname=kilgore-trout
NoNewPrivileges=true
Parameters=/bin/bash -c "./start-tor-browser --log /dev/stdout"
PrivateUsers=true
ProcessTwo=true
User=noroot
WorkingDirectory=/usr/local/bin/tor-browser
```

### Create a container

#### Using `systemd-nspawn`

```
$ sudo -s
# apt-get install debootstrap
# cd /var/lib/machines
# mkdir tor-browser
# debootstrap \
    --arch=amd64 \
    --variant=minbase \
    bullseye tor-browser http://deb.debian.org/debian
# cp /path/to/machines/hugo/install_tor_browser.sh tor-browser
# chroot tor-browser
# ./install_tor_browser.sh
# exit
# exit
```

#### Using Docker

```
$ sudo -s
# cd /var/lib/machines
# mkdir tor-browser
# docker export $(docker create btoll/tor-browser:latest) | tar -x -C tor-browser
# systemd-nspawn -M tor-browser
```

# References

- [On Running systemd-nspawn Containers]
- [jessfraz/tor-browser on Docker Hub](https://hub.docker.com/r/jessfraz/tor-browser)
- [Jessie Frazelle's Blog](https://blog.jessfraz.com/)

[On Running systemd-nspawn Containers]: https://benjamintoll.com/2022/02/04/on-running-systemd-nspawn-containers/
[examples]: https://benjamintoll.com/2022/02/04/on-running-systemd-nspawn-containers/#examples

