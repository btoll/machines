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
Bind=/home/btoll/deb-build:/root/build
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
$ ./gpg-preset-passphrase.sh
$ sudo systemd-nspawn \
    --machine deb-packaging \
    --setenv PACKAGE_NAME=asbits \
    --setenv PACKAGE_VERSION=1.0.0 \
    --quiet
```

You may get errors similar to the following, but you can ignore them:

```bash
gpg: Warning: using insecure memory!
```

> The `USER` defaults to `uid 1000` (see the `deb-packaging.nspawn` config above), so if you want to change that use the command-line `--setenv` option.

### Verify the Signatures

```bash
$ gpg --verify asbits_1.0.0.dsc
gpg: Signature made Tue 27 Jun 2023 10:27:32 PM EDT
gpg:                using RSA key D81CBD13350F3BD123988DC83A1314344B0D9912
gpg: Good signature from "Debian <ben@benjamintoll.com>" [ultimate]
```

Verify the `.changes` and `.buildinfo` signatures the same way.

I'm not going to use the `debsig-verify` tool to verify the concatenated signature of the `_gpgorigin` file within the `deb` package, but it can be done another way:

```bash
$ mkdir tmp && cd $_
$ cp ../asbits_1.0.0_amd64.deb  .
$ ar x asbits_1.0.0_amd64.deb
$ ls
asbits_1.0.0_amd64.deb  control.tar.xz  data.tar.xz  debian-binary  _gpgorigin
$ gpg --verify _gpgorigin debian-binary control.tar.xz data.tar.xz
gpg: Signature made Tue 27 Jun 2023 10:27:34 PM EDT
gpg:                using RSA key D81CBD13350F3BD123988DC83A1314344B0D9912
gpg: Good signature from "Debian <ben@benjamintoll.com>" [ultimate]
```

Since the `_gpgorigin` file is a detached signature that is a concatenation of the three files that make up the `ar` archive which is the `deb` package, you **must** list them in order on the command-line when verifying or the verification will fail.

## References

- [On Creating deb Packages](https://benjamintoll.com/2023/06/21/on-creating-deb-packages/)
- [On debsigs](https://benjamintoll.com/2023/06/24/on-debsigs/)
- [On Inspecting deb Packages](https://benjamintoll.com/2023/06/01/on-inspecting-deb-packages/)
- [On gpg-agent Forwarding](https://benjamintoll.com/2023/06/07/on-gpg-agent-forwarding/)

