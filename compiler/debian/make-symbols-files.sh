#!/bin/bash
#
# Generate .symbols files from .debs
#
set -e

# Parse arguments
FORCE=false
while getopts "f" opt; do
  case $opt in
    f)
      FORCE=true
      ;;
    *)
      echo "Usage: $0 [-f]"
      echo "  -f  Force overwrite existing symbols files"
      exit 1
      ;;
  esac
done

pushd .. > /dev/null
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

  # Determine the -dev package name by replacing the trailing digit with -dev
  DEV_PKG=$(echo "$pkg" | sed 's/-\?[0-9]$/-dev/')

  # Check if symbols file exists and skip unless -f is set
  if [ -f "debian/$pkg.symbols" ] && [ "$FORCE" = false ]; then
    echo "Skipping $pkg (symbols file already exists, use -f to overwrite)"
    continue
  fi

  echo "Generating symbols for $pkg from $(basename "$DEB_FILE")..."
  rm -f debian/"$pkg".symbols
  dpkg-deb -x "$DEB_FILE" tmpdir
  dpkg-gensymbols -q -v"$VERSION" -p"$pkg" -Ptmpdir -Odebian/"$pkg".symbols.raw || true
  # Add Build-Depends-Package field after the first line
  sed -i "1a* Build-Depends-Package: $DEV_PKG" debian/"$pkg".symbols.raw
  sed 's/ \(_Z[^ ]*\)\( .*\)/ (c++)"\1"\2/' debian/"$pkg".symbols.raw | c++filt > debian/"$pkg".symbols
  rm -f debian/"$pkg".symbols.raw
  rm -rf tmpdir
done

popd > /dev/null
echo "Done! Symbols files generated in debian/"
