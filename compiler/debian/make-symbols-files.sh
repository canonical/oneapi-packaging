#!/bin/bash
#
# Generate .symbols files from .debs
#
set -e

pushd ..
VERSION=$(dpkg-parsechangelog -S Version | cut -f1 -d-)

PACKAGES=(
  libsycl8
  libur-loader0
  libur-adapter-level-zero0
  libur-adapter-level-zero-v2-0
  libur-adapter-opencl0
)

for pkg in "${PACKAGES[@]}"; do
  DEB_FILE=$(ls ../${pkg}_*.deb 2>/dev/null | head -n1)
  
  if [ -z "$DEB_FILE" ]; then
    echo "Warning: ../${pkg}_*.deb not found, skipping..."
    continue
  fi
  
  echo "Generating symbols for $pkg from $(basename "$DEB_FILE")..."
  dpkg-deb -x "$DEB_FILE" tmpdir
  dpkg-gensymbols -q -v"$VERSION" -p"$pkg" -Ptmpdir -Odebian/"$pkg".symbols.raw || true
  sed 's/ \(_Z[^ ]*\)\( .*\)/ (c++)"\1"\2/' debian/"$pkg".symbols.raw | c++filt > debian/"$pkg".symbols
  rm -f debian/"$pkg".symbols.raw
  rm -rf tmpdir
done

popd
echo "Done! Symbols files generated in debian/"
