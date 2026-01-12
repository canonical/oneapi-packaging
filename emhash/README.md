# emhash

To update and build this package:

```shell
uscan --rename --repack --download-version=1.0.0
cd ../emhash-1.0.0/
vim debian/changelog # edit changelog if necessary
sbuild -c resolute-amd64 --dist=resolute --build-path=""
```
