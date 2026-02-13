# emhash

To update and build this package:

```shell
uscan --download-version=1.0.0
cd ../ktprime-emhash-*
vim debian/changelog # edit changelog if necessary
sbuild -c resolute-amd64 --dist=resolute --build-path=""
```
