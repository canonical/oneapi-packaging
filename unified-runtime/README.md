# Unified Runtime Source Package

To update and build:

```bash
uscan --download-version=0.11.8
cd .. 
tar xvf unified-runtime_0.11.8.orig.tar.xz
cp -r unified-runtime/debian unified-runtime-0.11.8
cd unified-runtime-0.11.8
sbuild -c plucky-amd64 --dist=plucky --build-path=""
```