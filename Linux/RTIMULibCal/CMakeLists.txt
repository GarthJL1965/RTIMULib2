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
# Copyright 2026+ GJL - Start modernising, Add cross compile
#

CMAKE_MINIMUM_REQUIRED(VERSION 3.31.6)
PROJECT(RTIMULibCal LANGUAGES CXX)

# GJL:TODO
# Require C++17 (or newer if needed)
#set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)
#set(CMAKE_CXX_EXTENSIONS OFF)

option (ENABLE_CROSS_COMPILE "Enable cross compile RPATH settings" OFF)

if (ENABLE_CROSS_COMPILE)
  # Optional: Also set install RPATH for installed binaries
  # Use, ie don't skip the full RPATH for the build tree
  SET(CMAKE_SKIP_BUILD_RPATH FALSE)

  # When building, don't use the install RPATH
  # (but use later on when installing)
  SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
 
  # Set RPATH for the installed executable ** Needs to be done after target eg ADD_EXECUTABLE set **
  ##SET_TARGET_PROPERTIES(RTIMULibCal PROPERTIES
  ##    INSTALL_RPATH "\${ORIGIN}/../lib\${ORIGIN}/lib"  # Escape $ with \ to preserve it
  ##)

  # Add determined parts of RPATH which point to directories outside
  # build tree to the INSTALL RPATH
  #SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
  # Wasil Zafar : "Append to existing RPATH (Don't overwrite)
  # GJL : We WANT to overwrite the existing RPATH, else we end up with eg 
  #                                vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv <- wrong !!!
  # ${ORIGIN}/../lib:${ORIGIN}/lib:/home/gjl/dev/cpp/RTIMULib2/.local
  SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
endif()

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
SET(RTIMULibCal_SRCS
    RTIMULibCal.cpp
)

# Add your executable
ADD_EXECUTABLE(RTIMULibCal
    ${RTIMULibCal_SRCS}
)

if (ENABLE_CROSS_COMPILE)
  # Set RPATH for the installed executable
  SET_TARGET_PROPERTIES(RTIMULibCal PROPERTIES
  #    INSTALL_RPATH "\${ORIGIN}/../lib\${ORIGIN}/lib"  # Escape $ with \ to preserve it
      INSTALL_RPATH "\${ORIGIN}/../lib:\${ORIGIN}/lib"  # Escape $ with \ to preserve it
  )
endif()

# Link RTIMULib
TARGET_LINK_LIBRARIES(RTIMULibCal
    PRIVATE "${RTIMULIB_LIBRARY}"
)

INSTALL(TARGETS RTIMULibCal 
  DESTINATION bin
)

#[[ GJL - 'old'
SET(CAL_SRCS
    RTIMULibCal.cpp)

ADD_EXECUTABLE(RTIMULibCal ${CAL_SRCS})
TARGET_LINK_LIBRARIES(RTIMULibCal RTIMULib)

INSTALL(TARGETS RTIMULibCal DESTINATION bin)
]]

