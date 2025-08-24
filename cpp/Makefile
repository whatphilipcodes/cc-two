# Variables
BUILD_DIR = .build-cm
CMAKE = cmake
CMAKE_BUILD_TYPE = Release

LIBRAW_BUILD_SCRIPT = External/tools/LibRaw/build_libraw.sh
LIBRAW_XCFRAMEWORK = External/build/LibRaw/local/LibRaw.xcframework

SPM = swift build --configuration release
SPM_RUN = swift run ATMCLI

.PHONY: all build-libraw build-cpp build-swift run clean

all: build-libraw build-cpp build-swift run

# Build LibRaw XCFramework for iOS
build-libraw:
	@echo "Building LibRaw for iOS..."
	@bash $(LIBRAW_BUILD_SCRIPT)

# Build your C++ library (depends on LibRaw)
build-cpp: build-libraw
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && $(CMAKE) -DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE) ..
	cd $(BUILD_DIR) && $(CMAKE) --build . --config $(CMAKE_BUILD_TYPE)

# Build Swift code
build-swift:
	$(SPM)

run:
	$(SPM_RUN)

clean:
	rm -rf $(BUILD_DIR) External/build/LibRaw
	swift package clean