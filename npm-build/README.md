# npm-build  Dockerfile

## Create a container

```
$ cd /var/lib/machines
$ mkdir npm-build
$ docker export $(docker create btoll/npm-build:latest) | tar -x -C npm-build
$ sudo systemd-nspawn --quiet --bind $(pwd):/build --machine npm-build
```

## Create the service

`/etc/systemd/nspawn/npm-build.nspawn`

```
[Exec]
DropCapability=\
	CAP_NET_ADMIN \
	CAP_SETUID \
	CAP_SYS_ADMIN \
	CAP_SYS_CHROOT \
	CAP_SYS_RAWIO \
	CAP_SYSLOG
Hostname=kilgore-trout
NoNewPrivileges=true
Parameters=/bin/bash -c "npm install && npm run build"
PrivateUsers=true
ProcessTwo=true
ResolvConf=copy-host
Timezone=copy
User=node
WorkingDirectory=/build

```

