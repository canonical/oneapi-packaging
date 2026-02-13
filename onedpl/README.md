# OneDPL Source Package

To update and build:

```bash
uscan --download-version=2022.9.0
cd ../onedpl-2022.9.0
vim debian/changelog # edit manually if needed
```

Build the binary package:

```bash
sbuild -c resolute-amd64 --dist=resolute --build-path=""
```

Build the source package:

```bash
dpkg-buildpackage -S -d
```

If you are uploading a new upstream version for the first time, verify that the orig tarball is included in the upload (check in `*_source.changes`). If not, you can force include it using the `-sa` flag with `dpkg-buildpackage`.

Upload to LP:

```bash
# update .changes file name
dput ppa:kobuk-team/oneapi ../onedpl_2022.9.0-0ubuntu1~25.10~ppa9_source.changes
```

## Validation with autopkgtest

Tests can be run locally with autopkgtest. First install the dependencies:

```bash
sudo apt install dpkg-dev clang-dpcpp-21 onedpl-headers
```

Add your user to the `render` group (without this you will see nasty errors that generate core dumps):

```bash
sudo usermod -a -G render $USER
```

Log out, log back in, and finally run `autopkgtest`:

```bash
cd oneapi-packaging/compiler
autopkgtest -B -- null
```
