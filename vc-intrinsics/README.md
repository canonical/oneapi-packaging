# vc-intrinsics

To update and build this package:

```shell
uscan --download-version=0.22.0
cd ..
tar xvf intel-vc-intrinsics-0.22.0.tar.gz
cp -r vc-intrinsics/debian/ vc-intrinsics-0.22.0/
cd vc-intrinsics-0.22.0/
sbuild -c plucky-amd64 --dist=plucky --build-path=""
```
