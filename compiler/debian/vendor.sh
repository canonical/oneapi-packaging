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

# Vendor vc-intrinsics for these reasons:
#   - We need the source for in-tree build of the compiler
#   - The intel-vc-intrinsics debian package only includes headers
#   - The intel-vc-intrinsics debian package depends on an old version of llvm
git clone -b v0.22.0 --depth=1 https://github.com/intel/vc-intrinsics.git vendor/vc-intrinsics
cd vendor/vc-intrinsics
rm -rf .git .github .gitignore
cd ../..

# Vendor compute runtime level-zero headers for these reasons:
#   - The compiler requires a very specific version of the headers
#   - Headers enable experimental features not included in the level-zero API
#     and are only meant to be consumed by the DPC++ compiler at build-time
#   - More background and discussion: https://github.com/intel/llvm/issues/20318

# perform a sparse checkout since we only need a handful of headers
mkdir -p vendor/compute-runtime
cd vendor/compute-runtime
GIT_TAG="25.05.32567.17"
git init
git checkout -b main
git remote add origin https://github.com/intel/compute-runtime.git
git config core.sparsecheckout true
echo "level_zero/include" >> .git/info/sparse-checkout
git fetch --depth=1 origin "refs/tags/${GIT_TAG}:refs/tags/${GIT_TAG}"
git checkout "${GIT_TAG}"
rm -rf .git level_zero/include/{CMakeLists.txt,.clang-tidy}
cd ../..

tar --sort=name --owner=0 --group=0 --numeric-owner --clamp-mtime \
    --mtime="2024-01-01 00:00:00" \
    -cf ../intel-dpcpp_$PKG_VERSION.orig-vendor.tar vendor
gzip -n -9 ../intel-dpcpp_$PKG_VERSION.orig-vendor.tar
