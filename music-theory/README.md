# Music Theory Dockerfile

## Create a container

```
$ cd /var/lib/machines
$ mkdir music-theory
$ docker export $(docker create btoll/music-theory:latest) | tar -x -C music-theory
$ sudo systemd-nspawn --quiet --machine music-theory
```

## Create the service

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

