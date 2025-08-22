# Unified build directory structure
# build/
#   build-cm/   (CMake cache & C++ artifacts)
#   build-swift/ (SwiftPM scratch path)

BUILD_ROOT       = build
CMAKE_BUILD_DIR  = $(BUILD_ROOT)/build-cm
SWIFT_BUILD_DIR  = $(BUILD_ROOT)/build-swift

CMAKE            = cmake
CMAKE_BUILD_TYPE = Release

SWIFT_BASE_FLAGS = --configuration release --scratch-path $(SWIFT_BUILD_DIR)
SPM              = swift build $(SWIFT_BASE_FLAGS)
SPM_RUN          = swift run  $(SWIFT_BASE_FLAGS) ATMCLI

.PHONY: all build-cpp build-swift run clean tree

all: build-cpp build-swift run

build-cpp:
	@mkdir -p $(CMAKE_BUILD_DIR)
	$(CMAKE) -S . -B $(CMAKE_BUILD_DIR) -DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE)
	$(CMAKE) --build $(CMAKE_BUILD_DIR) --config $(CMAKE_BUILD_TYPE)

build-swift:
	@mkdir -p $(SWIFT_BUILD_DIR)
	$(SPM)

run:
	$(SPM_RUN)

clean:
	rm -rf $(BUILD_ROOT) .build
	swift package reset >/dev/null 2>&1 || true

# Convenience target to visualize directory layout (macOS/BSD tree fallback)
tree:
	@if command -v tree >/dev/null 2>&1; then tree -L 3 $(BUILD_ROOT); else find $(BUILD_ROOT) -maxdepth 3 -print; fi