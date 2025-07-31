# Unified Runtime Source Package

To update and build:

```bash
uscan --download-version=0.11.8
cd .. 
tar xvf unified-runtime_0.11.8.orig.tar.xz
cp -r unified-runtime/debian unified-runtime-0.11.8
cd unified-runtime-0.11.8
sbuild-apt plucky-amd64 apt-get install ca-certificates # only needs to be run once
sbuild -c plucky-amd64 --dist=plucky --build-path="" --extra-repository="deb [trusted=yes] https://ppa.launchpadcontent.net/kobuk-team/oneapi/ubuntu plucky main"
```