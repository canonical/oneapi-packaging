#!/bin/bash
#
# Generate .symbols files from .debs with regex patterns for C++ symbols
# and track symbol versions from previous releases
#
set -e

pushd ..
VERSION=$(dpkg-parsechangelog -S Version | cut -f1 -d-)
DEB_FILE="libdnnl-sycl3_3.10.2-0ubuntu1~26.04_amd64.deb"

# Try to use existing symbols file as a base to preserve version history
OLD_SYMBOLS=""
if [ -f debian/libdnnl-sycl3.symbols ]; then
    echo "Found existing symbols file, will preserve version information..."
    OLD_SYMBOLS="debian/libdnnl-sycl3.symbols"
fi

echo "Generating symbols from $(basename "$DEB_FILE")..."
dpkg-deb -x "../$DEB_FILE" tmpdir

# If we have an old symbols file, dpkg-gensymbols will use it to track versions
if [ -n "$OLD_SYMBOLS" ]; then
    dpkg-gensymbols -q -v"$VERSION" -plibdnnl-sycl3 -Ptmpdir -Odebian/libdnnl-sycl3.symbols.raw || true
else
    dpkg-gensymbols -q -v"$VERSION" -plibdnnl-sycl3 -Ptmpdir -Odebian/libdnnl-sycl3.symbols.raw || true
fi

# Demangle C++ symbols
sed 's/ \(_Z[^ ]*\)\( .*\)/ (c++)"\1"\2/' debian/libdnnl-sycl3.symbols.raw | c++filt > debian/libdnnl-sycl3.symbols.full

# Extract header and first line
head -n 1 debian/libdnnl-sycl3.symbols.full > debian/libdnnl-sycl3.symbols

# Add Build-Depends-Package field
echo "* Build-Depends-Package: libdnnl-sycl-dev" >> debian/libdnnl-sycl3.symbols

# Determine the base version to use (either from old file or current version)
BASE_VERSION="$VERSION"
if [ -n "$OLD_SYMBOLS" ]; then
    # Extract the oldest version mentioned in the old symbols file
    OLDEST=$(grep -o '[0-9]\+\.[0-9]\+[^"]*' "$OLD_SYMBOLS" | sort -V | head -1)
    if [ -n "$OLDEST" ]; then
        BASE_VERSION="$OLDEST"
    fi
fi

# Add regex patterns for boring C++ symbols
cat >> debian/libdnnl-sycl3.symbols << EOF
# boring C++ symbols
 (c++|regex|optional)"std::.*@Base" $BASE_VERSION
 (c++|regex|optional)"dnnl::impl::.*@Base" $BASE_VERSION
 (c++|regex|optional)"(typeinfo|vtable|guard variable|reference temporary|construction vtable|VTT for) .*@Base" $BASE_VERSION
 (c++|regex|optional)"(void|bool|int|unsigned) std::.*@Base" $BASE_VERSION
EOF

# Function to determine version for a symbol
get_symbol_version() {
    local symbol="$1"
    if [ -n "$OLD_SYMBOLS" ]; then
        # Try to find this symbol in the old file and extract its version
        local old_version=$(grep -F "$symbol" "$OLD_SYMBOLS" 2>/dev/null | grep -o '[0-9]\+\.[0-9]\+[^"]*' | tail -1)
        if [ -n "$old_version" ]; then
            echo "$old_version"
            return
        fi
    fi
    # Default to current version for new symbols
    echo "$VERSION"
}

# Process C++ symbols accidentally exported
echo "# C++ symbols accidentally exported" >> debian/libdnnl-sycl3.symbols
grep '^ (c++)"dnnl_' debian/libdnnl-sycl3.symbols.full | while IFS= read -r line; do
    symbol=$(echo "$line" | sed 's/ (c++)"\([^"]*\)".*/\1/')
    version=$(get_symbol_version "$symbol")
    echo "$line" | sed 's/ (c++)/ (c++|optional)/' | sed "s/@Base.*/@Base\" $version/"
done >> debian/libdnnl-sycl3.symbols

# Process internal symbols that leaked
echo "# internal symbols leaked" >> debian/libdnnl-sycl3.symbols
grep '^ (c++)' debian/libdnnl-sycl3.symbols.full | \
    grep -v '^ (c++)"dnnl_' | \
    grep -v 'std::' | \
    grep -v 'dnnl::impl::' | \
    grep -v 'typeinfo\|vtable\|guard variable\|reference temporary\|construction vtable\|VTT for' | while IFS= read -r line; do
    symbol=$(echo "$line" | sed 's/ (c++)"\([^"]*\)".*/\1/')
    version=$(get_symbol_version "$symbol")
    echo "$line" | sed 's/ (c++)/ (c++|optional)/' | sed "s/@Base.*/@Base\" $version/"
done >> debian/libdnnl-sycl3.symbols

# Add ITT library symbols section
echo "# C symbols in itt library that should not be visible" >> debian/libdnnl-sycl3.symbols
echo " (regex|optional)\"__itt.*@Base\" $BASE_VERSION" >> debian/libdnnl-sycl3.symbols

# Add actual C API symbols (plain C symbols without (c++) marker, excluding __itt symbols)
echo "# actual C symbols from libdnnl" >> debian/libdnnl-sycl3.symbols
grep -v '^ (c++)' debian/libdnnl-sycl3.symbols.full | grep '^ ' | grep -v ' __itt' >> debian/libdnnl-sycl3.symbols || true

rm -f debian/libdnnl-sycl3.symbols.raw debian/libdnnl-sycl3.symbols.full
rm -rf tmpdir

popd
echo "Done! Symbols file generated in debian/libdnnl-sycl3.symbols"
echo "Symbol versions preserved from previous releases where available."
