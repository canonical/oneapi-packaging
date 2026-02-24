# Unified Memory Framework Source Package

To update and build:

```bash
uscan --download-version=0.11.0
cd ../intel-umf-0.11.0/
vim debian/changelog # edit manually if needed
sbuild -c resolute-amd64 --dist=resolute --build-path=""
```
