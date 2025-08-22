# Unified Memory Framework Source Package

To update and build:

```bash
uscan --download-version=1.0.0+really0.11.0
cd intel-umf-1.0.0+really0.11.0/
vim debian/changelog # edit manually if needed
sbuild -c plucky-amd64 --dist=plucky --build-path=""
```