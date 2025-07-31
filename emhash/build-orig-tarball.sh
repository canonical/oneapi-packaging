#!/bin/bash -e
#
# debian/watch and uscan do not support
# fetching a git repo from a specific commit hash,
# so this script builds the orig tarball manually.
#

UPSTREAM_COMMIT_HASH="b7ff314"

cleanup() {
  echo "Cleaning up..."
  rm -rf "${tmpdir}"
}

trap cleanup EXIT

tmpdir=$(mktemp -d)
git clone https://github.com/ktprime/emhash "${tmpdir}/emhash"
pushd "${tmpdir}/emhash"
git checkout "${UPSTREAM_COMMIT_HASH}"

commit_date=$(git show -s --format=%cd --date=format:%Y%m%d HEAD)
upstream_version_string="0.0+git${commit_date}.${UPSTREAM_COMMIT_HASH}"
source_dir="emhash-${upstream_version_string}"
orig_tarball="emhash_${upstream_version_string}.orig.tar.gz"
popd

pushd ..
mkdir "${source_dir}"
cp "${tmpdir}/emhash/"*.{hpp,h} "${source_dir}"
tar -czvf "${orig_tarball}" "${source_dir}"
popd

# for convenience, copy the debian folder into the upstream source tree
cp -r debian ../"${source_dir}"
