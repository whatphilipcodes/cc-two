# Variables
BUILD_DIR = .build-cm
CMAKE = cmake
CMAKE_BUILD_TYPE = Release

LIBRAW_BUILD_SCRIPT = External/tools/LibRaw/build_libraw.sh
LIBRAW_XCFRAMEWORK = External/build/LibRaw/local/LibRaw.xcframework

SPM = swift build --configuration release
SPM_RUN = swift run AberrCLI

# Phony targets
.PHONY: all --build-libs build-libraw build-cpp build-swift run clean help

# Default: fast build (skip third-party libs)
all: build-cpp build-swift run

# Full build including third-party libs
--build-libs: build-libraw build-cpp build-swift run

# Build LibRaw XCFramework for iOS
build-libraw:
	@echo "Building LibRaw..."
	@bash $(LIBRAW_BUILD_SCRIPT)

# Build your C++ library (assumes libs already built unless you used --build-libs)
build-cpp:
	@if [ ! -d "$(LIBRAW_XCFRAMEWORK)" ]; then \
		echo "[ERROR] Missing LibRaw XCFramework at $(LIBRAW_XCFRAMEWORK)"; \
		echo "        Run: make --build-libs"; \
		exit 1; \
	fi
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

help:
	@echo "Usage:" 
	@echo "  make                # Build project (skip rebuilding third-party libs)"
	@echo "  make --build-libs    # Build third-party libs then project"
	@echo "  make build-libraw    # Only (re)build LibRaw"
	@echo "  make clean           # Clean build artifacts"