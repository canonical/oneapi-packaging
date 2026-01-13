#!/bin/bash
#
# Generate .symbols files from .debs
#
set -e

pushd ..
VERSION=$(dpkg-parsechangelog -S Version | cut -f1 -d-)
DEB_FILE="libdnnl-sycl3_3.10.2-0ubuntu1~26.04_amd64.deb"
  
echo "Generating symbols from $(basename "$DEB_FILE")..."
dpkg-deb -x "../$DEB_FILE" tmpdir
dpkg-gensymbols -q -v"$VERSION" -plibdnnl-sycl3 -Ptmpdir -Odebian/libdnnl-sycl3.symbols.raw || true
sed 's/ \(_Z[^ ]*\)\( .*\)/ (c++)"\1"\2/' debian/libdnnl-sycl3.symbols.raw | c++filt > debian/libdnnl-sycl3.symbols
rm -f debian/libdnnl-sycl3.symbols.raw
rm -rf tmpdir

popd
echo "Done! Symbols files generated in debian/"
