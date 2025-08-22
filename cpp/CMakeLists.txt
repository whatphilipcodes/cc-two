cmake_minimum_required(VERSION 3.15)
project(ATMWithdrawCpp LANGUAGES CXX)

# Locate the C++ library sources relative to project root
add_library(ATMWithdrawCpp STATIC
    ${CMAKE_CURRENT_SOURCE_DIR}/Sources/ATMWithdrawCpp/src/ATM.cpp
)

target_include_directories(ATMWithdrawCpp PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/Sources/ATMWithdrawCpp/include
    
)

set_target_properties(ATMWithdrawCpp PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
)
