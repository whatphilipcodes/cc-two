# Variables
BUILD_DIR = .build-cm
CMAKE = cmake
CMAKE_BUILD_TYPE = Release

SPM = swift build --configuration release
SPM_RUN = swift run ATMCLI

.PHONY: all build-cpp build-swift run clean

all: build-cpp build-swift run

build-cpp:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && $(CMAKE) -DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE) ..
	cd $(BUILD_DIR) && $(CMAKE) --build . --config $(CMAKE_BUILD_TYPE)

build-swift:
	$(SPM)

run:
	$(SPM_RUN)

clean:
	rm -rf $(BUILD_DIR)
	swift package clean