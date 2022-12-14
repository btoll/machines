# Music Theory Dockerfile

Note that the [`btoll/music-theory:latest`] image has already been created and pushed to Docker Hub.  See the [`music-theory` repository] on GitHub to view the [`Dockerfile`] and instructions on how to build the image.

## `systemd-nspawn`

### Create the service

> If this is the first config, you may have to create the `/etc/systemd/nspawn/` directory.

`/etc/systemd/nspawn/music-theory.nspawn`

```
[Exec]
DropCapability=all
Hostname=kilgore-trout
NoNewPrivileges=true
Parameters=python3 -m http.server
PrivateUsers=true
ProcessTwo=true
ResolvConf=copy-host
Timezone=copy
WorkingDirectory=/build

```

### Create a container

```
# cd /var/lib/machines
# mkdir music-theory
# docker export $(docker create btoll/music-theory:latest) | tar -x -C music-theory
# systemd-nspawn --machine music-theory
```

### Stopping the container

Press ^] three times within 1s to kill container.

[`btoll/music-theory:latest`]: https://hub.docker.com/r/btoll/music-theory
[`music-theory` repository]: https://github.com/btoll/music-theory
[`Dockerfile`]: https://github.com/btoll/music-theory/blob/master/Dockerfile

