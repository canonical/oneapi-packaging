# oneMath Source Package

To update and build:

```bash
uscan --rename --repack --download-version=0.9
cd ../onemath-0.9
vim debian/changelog # edit manually if needed
```

Build the binary package:

```bash
sbuild -c resolute-amd64 --dist=questing --build-path=""
```

Build the source package:

```bash
dpkg-buildpackage -S -d
```

If you are uploading a new upstream version for the first time, verify that the orig tarball is included in the upload (check in `*_source.changes`). If not, you can force include it using the `-sa` flag with `dpkg-buildpackage`.

Upload to LP:

```bash
```

## Validation with autopkgtest
