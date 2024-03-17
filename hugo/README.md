# Hugo

Create new articles and compile your markdown for your website with [Hugo] in a container.

The tag represents the version of Hugo.

## Installing

### Docker

```
$ docker pull btoll/hugo:0.80.0
```

[`btoll/hugo` on Docker Hub]

### `systemd-nspawn`

#### Create the service

> If this is the first config, you may have to create the `/etc/systemd/nspawn/` directory.

`/etc/systemd/nspawn/hugo.nspawn`

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
Parameters=/hugo.sh
PrivateUsers=true
ProcessTwo=true
ResolvConf=copy-host
Timezone=copy

[Files]
Bind=/home/btoll/projects/benjamintoll.com:/src
```

#### Get the root filesystem

#### Using Docker

As root:

```
# cd /var/lib/machines
# mkdir hugo
# docker export $(docker create btoll/hugo:0.80.0) | tar -x -C hugo
```

#### Using `systemd-nspawn`

```
$ sudo -s
# apt-get install debootstrap
# cd /var/lib/machines
# debootstrap \
    --arch=amd64 \
    --variant=minbase \
    bookworm hugo http://deb.debian.org/debian
# cp /path/to/machines/hugo/*hugo.sh hugo
# chroot hugo
# ./install_hugo.sh
# exit
# exit
```

## Supported configs

- `BASE_URL`
    + Defaults to `/`

- `DESTINATION`
    + `Hugo` will output the "compiled" website to this location on the host.  It will create the directory if not present.
    + Defaults to `public`

- `METHOD`
    + Both creating new articles and publish is supported.
        - Creating (`METHOD=new`) will add the file to the `./content/post/` directory on the host.
    + Defaults to `publish`

- `SOURCE`
    + This is the location in the container into which the host directory should be mapped via a bind mount.
    + If a custom location (other than `/src`) is needed, make sure to provide it as both the environment variable to `docker run` **and** and the destination location in the host to the bind mount (`-v`).
    + Defaults to `/src`

- `THEME`
    + Defaults to `hugo-lithium-theme`

## Supported themes

- [Hugo Lithium](https://github.com/jrutheiser/hugo-lithium-theme)
- [contrast-hugo](https://github.com/niklasbuschmann/contrast-hugo)

## Examples

### Creating a New Article

```
$ docker run --rm -e METHOD=new -e ARTICLE=soothing_the_savage_breast -v $HOME/projects/benjamintoll.com:/src btoll/hugo:0.80.0

or

$ sudo systemd-nspawn --machine hugo --setenv ARTICLE=soothing_the_savage_breast --setenv METHOD=new --setenv USER=1000 --quiet
```

> Change `--setenv USER=1000` to your user ID, otherwise it will default to `root`, which may not be what you want.

### Publishing

Use the `contrast-hugo` theme and output the results to the `out` directory on the host:

```
$ docker run --rm -e METHOD=publish -e THEME=contrast-hugo -e DESTINATION=out -v $HOME/projects/benjamintoll.com:/src btoll/hugo:0.80.0
```

> Note that `METHOD=publish` is unnecessary as `publish` is the default operation.

Use the default `hugo-lithium-them` theme and the default `public` destination on the host but change the location of the website source code to `foo`:

```
$ docker run --rm -e SOURCE=foo -v $HOME/projects/benjamintoll.com:/foo btoll/hugo:0.80.0
```

If using `systemd-nspawn` to manage your containers, you can publish like this:

```
$ sudo systemd-nspawn --machine hugo --setenv USER=1000 --quiet
```

> Change `--setenv USER=1000` to your user ID, otherwise it will default to `root`, which may not be what you want.

[Hugo]: https://gohugo.io/
[`btoll/hugo` on Docker Hub]: https://hub.docker.com/r/btoll/hugo

