# Specify C and C++ compilers (Xcode’s clang)
set(CMAKE_C_COMPILER /usr/bin/clang)
set(CMAKE_CXX_COMPILER /usr/bin/clang++)

# Specify minimum iOS version
set(IOS_PLATFORM "OS" CACHE STRING "iOS platform: OS or SIMULATOR64")
set(IOS_DEPLOYMENT_TARGET "13.0" CACHE STRING "Minimum iOS version")

# Detect platform
if(IOS_PLATFORM STREQUAL "SIMULATOR64")
    set(CMAKE_OSX_ARCHITECTURES x86_64)   # change to arm64 for Apple Silicon simulator if needed
    set(CMAKE_OSX_SYSROOT iphonesimulator)
else()
    set(CMAKE_OSX_ARCHITECTURES arm64)
    set(CMAKE_OSX_SYSROOT iphoneos)
endif()

# Specify that we are cross-compiling
set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_OSX_ARCHITECTURES})

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# Optional flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fembed-bitcode")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fembed-bitcode")
