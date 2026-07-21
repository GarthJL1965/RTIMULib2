# ============================================================
# CMakeDebugHelper.cmake
# A helper module to log variables, cache entries, and target
# properties during CMake configuration.
#
# Usage:
#   include(CMakeDebugHelper)
#
# Author: Senior CMake Expert
# ============================================================

cmake_minimum_required(VERSION 3.15)

# -------------------------------
# Function: Print all normal variables
# -------------------------------
function(print_all_variables)
    message(STATUS "===== NORMAL VARIABLES =====")
    get_cmake_property(_vars VARIABLES)
    list(SORT _vars)
    foreach(_var ${_vars})
        # Skip internal CMake variables if desired
        if(NOT _var MATCHES "^_")
            message(STATUS "${_var} = ${${_var}}")
        endif()
    endforeach()
endfunction()

# -------------------------------
# Function: Print all cache variables
# -------------------------------
function(print_all_cache_variables)
    message(STATUS "===== CACHE VARIABLES =====")
    get_cmake_property(_cacheVars CACHE_VARIABLES)
    list(SORT _cacheVars)
    foreach(_var ${_cacheVars})
        get_property(_help CACHE ${_var} PROPERTY HELPSTRING)
        get_property(_type CACHE ${_var} PROPERTY TYPE)
        message(STATUS "${_var} (${_type}) = ${${_var}}  # ${_help}")
    endforeach()
endfunction()

# -------------------------------
# Function: Print all targets and their properties
# -------------------------------
function(print_all_targets_and_properties)
    message(STATUS "===== TARGETS AND PROPERTIES =====")
    get_property(_targets DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY BUILDSYSTEM_TARGETS)
    list(SORT _targets)
    foreach(_tgt ${_targets})
        message(STATUS "Target: ${_tgt}")
        # List of common properties to inspect
        set(_props
            TYPE
            SOURCES
            INCLUDE_DIRECTORIES
            COMPILE_DEFINITIONS
            COMPILE_OPTIONS
            LINK_LIBRARIES
            INTERFACE_INCLUDE_DIRECTORIES
            INTERFACE_COMPILE_DEFINITIONS
            INTERFACE_COMPILE_OPTIONS
            INTERFACE_LINK_LIBRARIES
        )
        foreach(_prop ${_props})
            get_target_property(_val ${_tgt} ${_prop})
            if(NOT _val)
                set(_val "<EMPTY>")
            endif()
            message(STATUS "  ${_prop}: ${_val}")
        endforeach()
    endforeach()
endfunction()

# -------------------------------
# Execute all debug dumps
# -------------------------------
message(STATUS "===== CMAKE DEBUG HELPER START =====")
print_all_variables()
print_all_cache_variables()
print_all_targets_and_properties()
message(STATUS "===== CMAKE DEBUG HELPER END =====")

