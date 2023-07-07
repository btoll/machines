# rpm Packaging

Create and sign `rpm` binary and source packages.

## Installing

### `systemd-nspawn`

#### Create the service

> If this is the first config, you may have to create the `/etc/systemd/nspawn/` directory.

`/etc/systemd/nspawn/rpm-packaging.nspawn`

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
Parameters=/build_rpm.sh
PrivateUsers=true
ProcessTwo=true
ResolvConf=copy-host
Timezone=copy

[Files]
Bind=/home/btoll/projects/rpm-packages:/root/build
Bind=/run/user/1000/gnupg/S.gpg-agent:/root/.gnupg/S.gpg-agent
```

#### Get the Root Filesystem

#### Using `systemd-nspawn`

```
$ su -
# apt-get install rinse
# cd /var/lib/machines
# mkdir rpm-packaging
# rinse \
    --arch=amd64 \
    --distribution=centos-7 \
    --directory=rpm-packaging
# cp /path/to/machines/rpm-packaging/{install_rpm_packaging.sh,build_rpm.sh,spec} rpm-packaging
# chroot rpm-packaging
# ./install_rpm_packaging.sh
# exit
# exit
```

## Examples

### Building and Signing

```
$ ./gpg-preset-passphrase.sh
$ sudo systemd-nspawn \
    --machine rpm-packaging \
    --setenv PACKAGE_NAME=asbits \
    --setenv PACKAGE_VERSION=1.0.0 \
    --setenv USER=1000 \
    --quiet
```

> The `USER` defaults to `uid 1000` (see the `rpm-packaging.nspawn` config above), so if you want to change that use the command-line `--setenv` option.

You may get errors similar to the following, but you can ignore them:

```bash
gpg: Warning: using insecure memory!
```

In addition, if you remove the machine, you may need to first unmount both the `proc` and the `sys` filesystems:

```bash
sudo umount /var/lib/machines/rpm-packaging/proc /var/lib/machines/rpm-packaging/sys
```

After packaging two projects, the local directory that was bind mounted has these contents:

```bash
$ !tree
tree ~/projects/rpm-packages/
/home/btoll/projects/rpm-packages/
├── asbits
│   └── 1.0.0
│       └── asbits-1.0.0
│           ├── asbits-1.0.0-1.el7.src.rpm
│           ├── asbits-1.0.0-1.el7.x86_64.rpm
│           └── asbits_1.0.0.tar.gz
└── simple-chat
    └── 1.0.0
        └── simple-chat-1.0.0
            ├── simple-chat-1.0.0-1.el7.src.rpm
            ├── simple-chat-1.0.0-1.el7.x86_64.rpm
            └── simple-chat_1.0.0.tar.gz

6 directories, 6 files
```

## References

- [Debian `rinse`](https://salsa.debian.org/debian/rinse)
- [On Creating RPM Packages](https://benjamintoll.com/2023/06/21/on-creating-rpm-packages/)
- [On Inspecting RPM Packages](https://benjamintoll.com/2023/06/01/on-inspecting-rpm-packages/)
- [On gpg-agent Forwarding](https://benjamintoll.com/2023/06/07/on-gpg-agent-forwarding/)

