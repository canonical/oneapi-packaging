#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PKG_DIR=${SCRIPT_DIR}/../

set -e

# caller can provide the upstream version
if [ -n "$1" ]; then
    PKG_VERSION="$1"
else
    cd "${PKG_DIR}/"
    PKG_VERSION=$(dpkg-parsechangelog  | sed -rne 's/^Version: ([0-9.]+)[-+].*$$/\1/p')
fi

echo "vendoring for package ${PKG_VERSION}"

cd "${PKG_DIR}/"

rm -rf vendor
mkdir -p vendor/compute-runtime

# perform a sparse checkout since we only need a handful of headers
cd vendor/compute-runtime
git init
git checkout -b main
git remote add origin https://github.com/intel/compute-runtime.git
git config core.sparsecheckout true
echo "level_zero/include" >> .git/info/sparse-checkout
GIT_TAG=24.39.31294.12
git fetch --depth=1 origin refs/tags/${GIT_TAG}:refs/tags/${GIT_TAG}
git checkout ${GIT_TAG}
rm -rf .git level_zero/include/CMakeLists.txt
cd ../..

tar -C vendor --exclude-vcs --sort=name \
    --owner=0 --group=0 --numeric-owner --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime\
,delete=ctime \
    -zcf ../unified-runtime_$PKG_VERSION.orig-vendor.tar.gz .
