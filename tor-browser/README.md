# tor-browser Dockerfile

The Dockerfile uses Jessie Frazelle's [`tor-browser` Dockerfile](https://github.com/jessfraz/dockerfiles/tree/master/tor-browser) as for many of its bits.  There were enough changes to warrant its own Dockerfile.

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

As root:

```
# cd /var/lib/machines
# mkdir tor-browser
# docker export $(docker create btoll/tor-browser:latest) | tar -x -C tor-browser
# systemd-nspawn -M tor-browser
```

# References

- [On Running systemd-nspawn Containers](https://benjamintoll.com/2022/02/04/on-running-systemd-nspawn-containers/)
- [jessfraz/tor-browser on Docker Hub](https://hub.docker.com/r/jessfraz/tor-browser)
- [Jessie Frazelle's Blog](https://blog.jessfraz.com/)

