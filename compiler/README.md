# intel-dpcpp compiler package

## Build the debian package

```
uscan --download-version=6.2.0
cd ../intel-dpcpp-6.2.0/
vim debian/changelog # edit manually if needed
sudo apt build-dep ./
sbuild-apt resolute-amd64 apt-get install ca-certificates # only needs to be run once
sbuild -c resolute-amd64 --dist=questing --no-run-lintian --extra-repository="deb [trusted=yes] https://ppa.launchpadcontent.net/kobuk-team/oneapi/ubuntu questing main" --build-path=""
```

This avoids running `lintian` for now as it takes a very long time to run. The final option is important as it forces `sbuild` to use a different build path for each build. Otherwise, each build will share a build directory, which can result in strange errors.

## Validation with autopkgtest

Tests can be run locally with autopkgtest. First install the dependencies for the tests:

```bash
sudo apt install autopkgtest dpkg-dev cmake libstb-dev ocl-icd-opencl-dev clang-dpcpp-21
```

Since we are running `autopkgtest` with `-B` below, `autopkgtest` also requires the build dependencies for the compiler to be installed:

```bash
sudo apt install libur-loader-dev libur-adapter-level-zero-dev libur-adapter-level-zero-v2-dev libur-adapter-opencl-dev
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

Note that `-B` means that `autopkgtest` needs the debian package to already be installed. Otherwise, it will try to first build the package and test against that.
