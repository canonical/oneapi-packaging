#!/bin/bash -e
#
# debian/watch and uscan do not support
# fetching a git repo from a specific commit hash,
# so this script builds the orig tarball manually.
#

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
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

pushd "${SCRIPT_DIR}"/../..
mkdir "${source_dir}"
cp "${tmpdir}/emhash/"*.{hpp,h} "${source_dir}"
# TODO: for future releases, update this command to build
#       the tarball in a reproducible way. Currently this
#       vanilla approach results in a different md5sum each
#       time. For now, I will download the orig tarball from
#       Launchpad so the upload will not fail 
#tar -czvf "${orig_tarball}" "${source_dir}"
wget https://launchpad.net/~kobuk-team/+archive/ubuntu/oneapi/+sourcefiles/emhash/0.0+git20250614.b7ff314-0ubuntu1~25.04~ppa1/emhash_0.0+git20250614.b7ff314.orig.tar.gz
popd

# for convenience, copy the debian folder into the upstream source tree
cp -r "${SCRIPT_DIR}" "${SCRIPT_DIR}/../../${source_dir}"
