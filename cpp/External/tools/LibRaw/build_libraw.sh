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

IOS_DEVICE_ARCHS=("arm64")
IOS_SIM_ARCHS=("x86_64" "arm64")
MACOS_ARCHS=("x86_64" "arm64")

build_one () {
    local ARCH="$1"
    local PLATFORM="$2"  # ios ios-sim macos
    local SDK MINFLAG HOST EMBEDBITCODE
    case "$PLATFORM" in
        ios)
            SDK="iphoneos"
            MINFLAG="-miphoneos-version-min=13.0"
            EMBEDBITCODE="-fembed-bitcode"
            ;;
        ios-sim)
            SDK="iphonesimulator"
            MINFLAG="-mios-simulator-version-min=13.0"
            EMBEDBITCODE="-fembed-bitcode"
            ;;
        macos)
            SDK="macosx"
            MINFLAG="-mmacosx-version-min=11.0"
            EMBEDBITCODE=""   # bitcode not used on macOS
            ;;
    esac
    HOST="${ARCH}-apple-darwin"

    echo "Building LibRaw for $PLATFORM / $ARCH"
    local OUTDIR="$BUILD_DIR/${PLATFORM}-${ARCH}"
    mkdir -p "$OUTDIR"
    cd "$OUTDIR"

    local DEVROOT
    DEVROOT=$(xcrun --sdk $SDK --show-sdk-path)
    local CC CXX
    CC="$(xcrun --sdk $SDK -f clang)"
    CXX="$(xcrun --sdk $SDK -f clang++)"

    export CC CXX
    export CFLAGS="-arch $ARCH -isysroot $DEVROOT $MINFLAG $EMBEDBITCODE"
    export CXXFLAGS="$CFLAGS"
    export LDFLAGS="-arch $ARCH -isysroot $DEVROOT"

    "$LIBRAW_DIR/configure" \
        --disable-examples \
        --disable-openmp \
        --disable-shared \
        --enable-static \
        --host=$HOST \
        --prefix="$INSTALL_DIR/${PLATFORM}-${ARCH}"

    make -j"$(sysctl -n hw.ncpu)"
    make install
}

# Build per-arch slices
for A in "${IOS_DEVICE_ARCHS[@]}"; do build_one "$A" ios; done
for A in "${IOS_SIM_ARCHS[@]}";    do build_one "$A" ios-sim; done
for A in "${MACOS_ARCHS[@]}";      do build_one "$A" macos; done

# Combine simulator and macOS into universal libs
echo "Creating universal simulator lib..."
SIM_UNI_DIR="$INSTALL_DIR/ios-sim-universal"
mkdir -p "$SIM_UNI_DIR/lib" "$SIM_UNI_DIR/include"
lipo -create \
    "$INSTALL_DIR/ios-sim-x86_64/lib/libraw.a" \
    "$INSTALL_DIR/ios-sim-arm64/lib/libraw.a" \
    -output "$SIM_UNI_DIR/lib/libraw.a"
cp -R "$INSTALL_DIR/ios-sim-arm64/include/"* "$SIM_UNI_DIR/include/"

echo "Creating universal macOS lib..."
MAC_UNI_DIR="$INSTALL_DIR/macos-universal"
mkdir -p "$MAC_UNI_DIR/lib" "$MAC_UNI_DIR/include"
lipo -create \
    "$INSTALL_DIR/macos-x86_64/lib/libraw.a" \
    "$INSTALL_DIR/macos-arm64/lib/libraw.a" \
    -output "$MAC_UNI_DIR/lib/libraw.a"
cp -R "$INSTALL_DIR/macos-arm64/include/"* "$MAC_UNI_DIR/include/"

# Create XCFramework (one entry per platform)
xcodebuild -create-xcframework \
    -library "$INSTALL_DIR/ios-arm64/lib/libraw.a" -headers "$INSTALL_DIR/ios-arm64/include" \
    -library "$SIM_UNI_DIR/lib/libraw.a" -headers "$SIM_UNI_DIR/include" \
    -library "$MAC_UNI_DIR/lib/libraw.a" -headers "$MAC_UNI_DIR/include" \
    -output "$INSTALL_DIR/LibRaw.xcframework"

echo "LibRaw XCFramework built at $INSTALL_DIR/LibRaw.xcframework"
