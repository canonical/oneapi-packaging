#!/bin/bash
#
# Generate .symbols files from .debs
#
set -e

pushd ..
VERSION=$(dpkg-parsechangelog -S Version | cut -f1 -d-)
DEB_FILE="libumf0_0.11.0-0ubuntu1~26.04_amd64.deb"
  
echo "Generating symbols from $(basename "$DEB_FILE")..."
dpkg-deb -x "../$DEB_FILE" tmpdir
dpkg-gensymbols -q -v"$VERSION" -plibumf0 -Ptmpdir -Odebian/libumf0.symbols.raw || true
# Add Build-Depends-Package field after the first line
sed -i '1a* Build-Depends-Package: libumf-dev' debian/libumf0.symbols.raw
sed 's/ \(_Z[^ ]*\)\( .*\)/ (c++)"\1"\2/' debian/libumf0.symbols.raw | c++filt > debian/libumf0.symbols
rm -f debian/libumf0.symbols.raw
rm -rf tmpdir

popd
echo "Done! Symbols files generated in debian/"
