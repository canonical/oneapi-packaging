# Unified Memory Framework Source Package

To update and build:

```bash
uscan --download-version=0.10.0
cd ../intel-umf-0.10.0
vim debian/changelog # edit manually if needed
sbuild -c plucky-amd64 --dist=plucky --build-path=""
```