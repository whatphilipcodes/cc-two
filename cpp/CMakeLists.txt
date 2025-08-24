cmake_minimum_required(VERSION 3.15)
project(AberrCore LANGUAGES CXX)

# Paths to LibRaw XCFramework
set(LIBRAW_XCFRAMEWORK "${CMAKE_CURRENT_SOURCE_DIR}/External/build/LibRaw/local/LibRaw.xcframework")
set(LIBRAW_HEADERS "${LIBRAW_XCFRAMEWORK}/ios-arm64/Headers")
set(LIBRAW_LIB "${LIBRAW_XCFRAMEWORK}/ios-arm64/libraw.a")

# Check LibRaw
if(NOT EXISTS ${LIBRAW_LIB})
    message(FATAL_ERROR "LibRaw not built for iOS! Run 'make build-libraw' first.")
endif()
if(NOT EXISTS ${LIBRAW_HEADERS})
    message(FATAL_ERROR "LibRaw include folder not found! Run 'make build-libraw'.")
endif()

# Your C++ library
add_library(AberrCore STATIC
    ${CMAKE_CURRENT_SOURCE_DIR}/Sources/AberrCore/src/Aberr.cpp
)

# Include directories
target_include_directories(AberrCore PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/Sources/AberrCore/include
    ${LIBRAW_HEADERS}
)

# Link LibRaw
target_link_libraries(AberrCore PUBLIC
    ${LIBRAW_LIB}
)

# Target properties
set_target_properties(AberrCore PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
)
