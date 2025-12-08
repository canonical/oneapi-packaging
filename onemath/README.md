# oneMath Source Package

To update and build:

```bash
uscan --rename --repack --download-version=0.9
cd ../onemath-0.9
vim debian/changelog # edit manually if needed
```

Build the binary package:

```bash
sbuild -c questing-amd64 --dist=questing --build-path="" --extra-repository="deb [trusted=yes] http://HTTPS///ppa.launchpadcontent.net/kobuk-team/oneapi-dev/ubuntu questing main"
```

Build the source package:

```bash
dpkg-buildpackage -S -d
```

If you are uploading a new upstream version for the first time, verify that the orig tarball is included in the upload (check in `*_source.changes`). If not, you can force include it using the `-sa` flag with `dpkg-buildpackage`.

Upload to LP (double check which PPA you want to publish to, here we're publishing to [ppa:kobuk-team/oneapi-dev](https://launchpad.net/~kobuk-team/+archive/ubuntu/oneapi-dev)):

```bash
dput ppa:kobuk-team/oneapi-dev ../onemath_0.9-0ubuntu1~26.04~ppa1_source.changes
```

## Validation with autopkgtest (TODO)
