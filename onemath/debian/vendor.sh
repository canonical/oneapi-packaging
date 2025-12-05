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

rm -rf vendor
mkdir -p vendor

# Vendor generic SYCL BLAS and portFFT backends for these reasons:
#   - These are both specifically to support oneMATH without other use cases.
#   - Upstream downloads both dependencies in CMake via FetchContent, which is
#     not allowed in Launchpad

git clone https://github.com/uxlfoundation/generic-sycl-components.git vendor/generic-sycl-components
cd vendor/generic-sycl-components
GIT_COMMIT_HASH="9924112" # for reproducibility, upstream pulls from tip of main
git checkout "${GIT_COMMIT_HASH}"
rm -rf .git .github
cd ../..

git clone https://github.com/codeplaysoftware/portFFT vendor/portfft-src
cd vendor/portfft-src
GIT_COMMIT_HASH="f29d8e7" # consistent with upstream
git checkout "${GIT_COMMIT_HASH}"
rm -rf .git .github
cd ../..

tar --sort=name --owner=0 --group=0 --numeric-owner --clamp-mtime \
    --mtime="2025-01-01 00:00:00" \
    -cf ../onemath_$PKG_VERSION.orig-vendor.tar vendor
gzip -n -9 ../onemath_$PKG_VERSION.orig-vendor.tar
