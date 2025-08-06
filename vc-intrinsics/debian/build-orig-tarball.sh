#!/bin/bash -e
#
# debian/watch and uscan do not support
# fetching a git repo from a specific branch,
# so this script builds the orig tarball manually.
#

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
UPSTREAM_BRANCH="dpcpp_staging"

cleanup() {
  echo "Cleaning up..."
  rm -rf "${tmpdir}"
}

trap cleanup EXIT

tmpdir=$(mktemp -d)
git clone -b "${UPSTREAM_BRANCH}" https://github.com/intel/vc-intrinsics "${tmpdir}/vc-intrinsics"
pushd "${tmpdir}/vc-intrinsics"

commit_date=$(git show -s --format=%cd --date=format:%Y%m%d HEAD)
commit_hash=$(git rev-parse --short=6 HEAD)
# This version string sorts after the latest release (0.19.0) but makes
# it clear that it is actually based on a separate branch
upstream_version_string="0.19.0+really.dpcpp-staging.git${commit_date}.${commit_hash}"
source_dir="intel-vc-intrinsics-${upstream_version_string}"
orig_tarball="intel-vc-intrinsics_${upstream_version_string}.orig.tar"
popd

pushd "${SCRIPT_DIR}"/../..
mkdir "${source_dir}"
rm -rf "${tmpdir}/vc-intrinsics/".git
cp -r "${tmpdir}/vc-intrinsics/"* "${source_dir}"
tar --sort=name --owner=0 --group=0 --numeric-owner --clamp-mtime \
    --mtime="2024-01-01 00:00:00" \
    -cf "${orig_tarball}" "${source_dir}"
gzip -n -9 "${orig_tarball}"
popd

# for convenience, copy the debian folder into the upstream source tree
cp -r "${SCRIPT_DIR}" "${SCRIPT_DIR}/../../${source_dir}"
