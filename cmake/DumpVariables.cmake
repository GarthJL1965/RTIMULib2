# DumpVariables.cmake
# Minimal CMake module to print all normal and cache variables
# Usage: 
#   list(APPEND CMAKE_MODULE_PATH "${CMAKE_MODULE_DIR}/cmake")  (or)
#   list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
#   include(DumpVariables)

# Print all normal (non-cache) variables
message(STATUS "=== All CMake Variables (non-cache) ===")
get_cmake_property(_allVars VARIABLES)
list(SORT _allVars)
foreach(_var ${_allVars})
    message(STATUS "${_var} = [${${_var}}]")
endforeach()

# Print all cache variables
message(STATUS "=== All CMake Cache Variables ===")
get_cmake_property(_cacheVars CACHE_VARIABLES)
list(SORT _cacheVars)
foreach(_var ${_cacheVars})
    get_property(_help CACHE ${_var} PROPERTY HELPSTRING)
    get_property(_type CACHE ${_var} PROPERTY TYPE)
    message(STATUS "${_var} (${_type}) = [${${_var}}]  # ${_help}")
endforeach()

