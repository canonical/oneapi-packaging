# oneDNN Source Package

Note, debian and Ubuntu ship their own [onednn source package](https://launchpad.net/ubuntu/+source/onednn), which supports CPU only and is built with GCC. This new package will be built with the DPC++ toolchain (including the SYCL library) and thus support Intel GPUs.

## Update and build:

```bash
uscan --download-version=3.9.1
cd ..
tar xvf onednn_3.9.1.orig.tar.xz
cd uxlfoundation-oneDNN-*
cp -r ../onednn/debian .
```

Note, the `debian/watch` file uses version 5 which is not supported on Noble, so you may need to run the `uscan` command on a machine running a newer Ubuntu release.

## Build the binary package with sbuild

Docs for setting up `sbuild` and a `questing-amd64` schroot can be found [here](https://github.com/canonical/partner-eng-docs/blob/main/packaging/debian/sbuild.md). The command below adds the oneapi-dev PPA to the apt sources inside the schroot and uses an unusual URL that enables apt-cacher-ng to cache packages from the PPA. Those details can be found in [this section](https://github.com/canonical/partner-eng-docs/blob/main/packaging/debian/sbuild.md#using-the-schroot).

```bash
sbuild -c questing-amd64 --dist=questing --build-path="" --extra-repository="deb [trusted=yes] http://HTTPS///ppa.launchpadcontent.net/kobuk-team/oneapi-dev/ubuntu questing main"
```

## Build the source package with dpkg-buildpackage

```bash
dpkg-buildpackage -S -d
```

If you are uploading a new upstream version for the first time, verify that the orig tarball is included in the upload (check in `*_source.changes`). If not, you can force include it using the `-sa` flag with `dpkg-buildpackage`.

Upload to LP (double check which PPA you want to publish to, here we're publishing to [ppa:kobuk-team/oneapi-dev](https://launchpad.net/~kobuk-team/+archive/ubuntu/oneapi-dev)):

```bash
dput ppa:kobuk-team/oneapi-dev ../onednn_3.1.12-0ubuntu1~26.04~ppa1_source.changes
```

## Validation with autopkgtest (TODO)