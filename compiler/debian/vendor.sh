#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PKG_DIR=${SCRIPT_DIR}/../

# caller can provide the upstream version
if [ -n "$1" ]; then
    PKG_VERSION="$1"
else
    cd ${PKG_DIR}/
    PKG_VERSION=$(dpkg-parsechangelog  | sed -rne 's/^Version: ([0-9.]+)[-+].*$$/\1/p')
fi

echo "vendoring for package ${PKG_VERSION}"

cd ${PKG_DIR}/
#python3 ./buildbot/configure.py

rm -rf vendor
mkdir -p vendor

git clone -b v0.11.8 --depth=1 https://github.com/oneapi-src/unified-runtime.git vendor/unified-runtime
git clone https://github.com/ktprime/emhash vendor/emhash
git -C vendor/emhash/ reset --hard b7ff3147a5b206d6fccd52cd3d63cdbfc4acf8fd
git clone -b v2.0.0 --depth=1 https://github.com/greg7mdp/parallel-hashmap.git  vendor/parallel-hashmap
git clone -b boost-1.88.0 --depth=1 https://github.com/boostorg/mp11.git vendor/mp11-boost
git clone -b dpcpp_staging --depth=1 https://github.com/intel/vc-intrinsics.git vendor/vc-intrinsics
git clone -b 24.39.31294.12 https://github.com/intel/compute-runtime.git vendor/compute-runtime/

tar -C vendor --exclude-vcs --sort=name \
    --owner=0 --group=0 --numeric-owner --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime\
,delete=ctime \
    -zcf ../intel-dpcpp_$PKG_VERSION.orig-vendor.tar.gz .
