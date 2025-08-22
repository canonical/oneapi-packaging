# emhash

To update and build this package:

```shell
uscan --download-version=1.0.0
cd ../emhash-1.0.0/
vim debian/changelog # edit changelog if necessary
sbuild -c plucky-amd64 --dist=plucky --build-path=""
```
