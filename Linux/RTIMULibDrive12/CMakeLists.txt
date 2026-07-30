#////////////////////////////////////////////////////////////////////////////
#//
#//  This file is part of RTIMULib
#//
#//  Copyright (c) 2014-2015, richards-tech, LLC
#//
#//  Permission is hereby granted, free of charge, to any person obtaining a copy of
#//  this software and associated documentation files (the "Software"), to deal in
#//  the Software without restriction, including without limitation the rights to use,
#//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
#//  Software, and to permit persons to whom the Software is furnished to do so,
#//  subject to the following conditions:
#//
#//  The above copyright notice and this permission notice shall be included in all
#//  copies or substantial portions of the Software.
#//
#//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
#//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#// The cmake support was based on work by Moritz Fischer at ettus.com.
#// Original copyright notice:
#
# Copyright 2014 Ettus Research LLC
#
# Copyright 2026 GJL : Extending for cross-compile & Later 'Modernising' Work based on previous ettus et al
# Also see https://runebook.dev/en/docs/cmake/variable/cmake_install_prefix and the usage of GNUInstallDirs 
#   vs CMAKE_INSTALL_PREFIX
#

CMAKE_MINIMUM_REQUIRED(VERSION 3.31.6)
PROJECT(RTIMULibDrive12 LANGUAGES CXX)

# GJL:TODO
# Require C++17 (or newer if needed)
#set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)
#set(CMAKE_CXX_EXTENSIONS OFF)

# ** GJL - Could use option ENABLE_CROSS_COMPILE as per RTIMULibCal
# Optional: Also set install RPATH for installed binaries
SET(CMAKE_SKIP_BUILD_RPATH FALSE)
SET(CMAKE_BUILD_RPATH_USE_ORIGIN TRUE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
# This SET Below cal also be done as target properties after ADD_EXECUTABLE
SET(CMAKE_INSTALL_RPATH "\$ORIGIN/../lib:\$ORIGIN/lib")
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)

# Expand $HOME to an absolute path - We use this because we want cross-compiled lib only!
FILE(TO_CMAKE_PATH "$ENV{HOME}/dev/cpp/RTIMULib2/.local" RTIMULIB_LOCAL_PATH)

message(STATUS "RTIMULIB_LOCAL_PATH: ${RTIMULIB_LOCAL_PATH}")

# Restrict library search to local directory only
# This prevents picking up system-installed RTIMULib
FIND_LIBRARY(RTIMULIB_LIBRARY
#   NAMES libRTIMULib.so  <-- can actually do this apparently
    NAMES RTIMULib
    PATHS 
        "${RTIMULIB_LOCAL_PATH}/lib"
        "${CMAKE_SOURCE_DIR}/lib" 
        "${CMAKE_BINARY_DIR}/lib"
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH
    REQUIRED
)
if(RTIMULIB_LIBRARY)
    message(STATUS "RTIMULib Library found at: ${RTIMULIB_LIBRARY}")
else()
    message(FATAL_ERROR "Library not found!")
endif()

# Add Sources - no globbing !
SET(RTIMULibDrive12_SRCS
#   src/RTIMULibDrive12.cpp
    iDigFunctions.cpp
    RTIMULibDrive12.cpp
)

# Add your executable
ADD_EXECUTABLE(RTIMULibDrive12
    ${RTIMULibDrive12_SRCS}
)

# Link RTIMULib
TARGET_LINK_LIBRARIES(RTIMULibDrive12 
    PRIVATE "${RTIMULIB_LIBRARY}"
)

# Include headers if needed
TARGET_INCLUDE_DIRECTORIES(RTIMULibDrive12 PRIVATE
    "${CMAKE_SOURCE_DIR}/include"
    "${RTIMULIB_LOCAL_PATH}/include"
)

# Automatically copy libRTIMULib.so into build output directory
add_custom_command(
    TARGET RTIMULibDrive12 POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${RTIMULIB_LOCAL_PATH}/lib/libRTIMULib.so"
        "$<TARGET_FILE_DIR:RTIMULibDrive12>"
    COMMENT "Copying libRTIMULib.so to build output directory"
)

# Optional: Install rules
INSTALL(TARGETS RTIMULibDrive12 
    RUNTIME DESTINATION bin)
# install libRTIMULib.so not required here, is done from own build
#INSTALL(FILES "${RTIMULIB_LOCAL_PATH}/lib/libRTIMULib.so"
#    DESTINATION bin
#)

# GJL:TODO - Remove all below
#SET(DRIVE_SRCS
#    RTIMULibDrive12.cpp)
#
#ADD_EXECUTABLE(RTIMULibDrive12 ${DRIVE_SRCS})
#TARGET_LINK_LIBRARIES(RTIMULibDrive12 RTIMULib)
#
#INSTALL(TARGETS RTIMULibDrive12 DESTINATION bin)

