# Unified Runtime Source Package

To update and build:

```bash
# the -0 appended is a hack because I needed to include an additional vendor
# orig tarball in the upload with the experimental level-zero headers
uscan --download-version=0.11.8-0
cd ../unified-runtime-0.11.8-0
vim debian/changelog  # remove new entry created by uupdate
sbuild-apt plucky-amd64 apt-get install ca-certificates # only needs to be run once
sbuild -c plucky-amd64 --dist=plucky --build-path="" --extra-repository="deb [trusted=yes] https://ppa.launchpadcontent.net/kobuk-team/oneapi/ubuntu plucky main"
```