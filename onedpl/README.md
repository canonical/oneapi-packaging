# OneDPL Source Package

To update and build:

```bash
uscan --download-version=2022.9.0
cd ../onedpl-2022.9.0
vim debian/changelog # edit manually if needed
```

If this is a new upstream version or you are building for a new series for the first time, you need to rename the .tar.xz source file and delete the sym link, as the sym link is not handled properly for `dpkg-buildpackage` and `dput` (TODO: research how to overcome this manual step). For example:

```bash
rm onedpl_2022.9.0.orig.tar.xz
mv onedpl-2022.9.0.tar.xz onedpl_2022.9.0.orig.tar.xz
```

Also verify in your *_source.changes file that `dpkg-buildpackage` has included the orig tarball for the upload correctly. If it's not, the upload will likely fail and you will need to bump your version string and re-upload with the orig tarball included this time.

Build the binary package:

```bash
sbuild -c questing-amd64 --dist=questing --build-path=""
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
sudo apt install dpkg-dev clang-dpcpp-21
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