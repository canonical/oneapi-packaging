#!/bin/bash -e
#
# Build the orig tarball manually since we only need
# a handful of headers from the upstream repo.
#

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PKG_VERSION="24.39.31294.12"
SOURCE_PKG="intel-compute-runtime-exp-headers"

cleanup() {
  echo "Cleaning up..."
  rm -rf "${tmpdir}"
}

trap cleanup EXIT

tmpdir=$(mktemp -d)
mkdir "${tmpdir}/${SOURCE_PKG}"

# perform a sparse checkout since we only need a handful of headers
pushd "${tmpdir}/${SOURCE_PKG}"
git init
git checkout -b main
git remote add origin https://github.com/intel/compute-runtime.git
git config core.sparsecheckout true
echo "level_zero/include" >> .git/info/sparse-checkout
git fetch --depth=1 origin "refs/tags/${PKG_VERSION}:refs/tags/${PKG_VERSION}"
git checkout "${PKG_VERSION}"
rm -rf .git level_zero/include/{CMakeLists.txt,.clang-tidy}

source_dir="${SOURCE_PKG}-${PKG_VERSION}"
orig_tarball="${SOURCE_PKG}_${PKG_VERSION}.orig.tar"
popd

pushd "${SCRIPT_DIR}"/../..
mkdir "${source_dir}"
cp -r "${tmpdir}/${SOURCE_PKG}/"* "${source_dir}"
tar --sort=name --owner=0 --group=0 --numeric-owner --clamp-mtime \
    --mtime="2024-01-01 00:00:00" \
    -cf "${orig_tarball}" "${source_dir}"
gzip -n -9 "${orig_tarball}"
popd

# for convenience, copy the debian folder into the upstream source tree
cp -r "${SCRIPT_DIR}" "${SCRIPT_DIR}/../../${source_dir}"
