# OneDPL Source Package

To update and build:

```bash
uscan --download-version=2022.9.0
cd ../onedpl-2022.9.0
vim debian/changelog # edit manually if needed
sbuild -c plucky-amd64 --dist=plucky --build-path=""
```