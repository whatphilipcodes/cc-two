#!/bin/bash
set -e

# Paths
LIBRAW_DIR="$(pwd)/External/LibRaw"
BUILD_DIR="$(pwd)/External/build/LibRaw"
INSTALL_DIR="$BUILD_DIR/local"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Generate configure script if missing
if [ ! -f "$LIBRAW_DIR/configure" ]; then
    echo "Configure script not found. Running autoreconf..."
    cd "$LIBRAW_DIR"
    autoreconf --install
fi

# Architectures to build
ARCHS=("arm64" "x86_64")  # device + simulator

for ARCH in "${ARCHS[@]}"; do
    echo "Building LibRaw for $ARCH..."
    mkdir -p "$BUILD_DIR/$ARCH"
    cd "$BUILD_DIR/$ARCH"

    if [ "$ARCH" = "arm64" ]; then
        SDK="iphoneos"
    else
        SDK="iphonesimulator"
    fi

    DEVROOT=$(xcrun --sdk $SDK --show-sdk-path)
    CC="$(xcrun --sdk $SDK -f clang)"
    CXX="$(xcrun --sdk $SDK -f clang++)"

    export CC CXX
    export CFLAGS="-arch $ARCH -isysroot $DEVROOT -mios-version-min=13.0 -fembed-bitcode"
    export CXXFLAGS="$CFLAGS"
    export LDFLAGS="-arch $ARCH -isysroot $DEVROOT"

    "$LIBRAW_DIR/configure" \
        --disable-examples \
        --disable-openmp \
        --disable-shared \
        --enable-static \
        --host=$ARCH-apple-darwin \
        --prefix="$INSTALL_DIR/$ARCH"


    make -j$(sysctl -n hw.ncpu)
    make install
done

# Create XCFramework
xcodebuild -create-xcframework \
    -library "$INSTALL_DIR/arm64/lib/libraw.a" -headers "$INSTALL_DIR/arm64/include" \
    -library "$INSTALL_DIR/x86_64/lib/libraw.a" -headers "$INSTALL_DIR/x86_64/include" \
    -output "$INSTALL_DIR/LibRaw.xcframework"

echo "LibRaw XCFramework built at $INSTALL_DIR/LibRaw.xcframework"
