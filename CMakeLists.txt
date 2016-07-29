cmake_minimum_required (VERSION 2.8 FATAL_ERROR)
project( automation )

# -- build variables -----------------------------------------------------------
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pedantic -Wall -Werror -Wextra" )
set( AUTOMATION_VERSION_MAJOR 0 )
set( AUTOMATION_VERSION_MINOR 1 )
set( AUTOMATION_VERSION_PATCH 0 )
set( AUTOMATION_VERSION ${AUTOMATION_MAJOR_VERSION}.${AUTOMATION_MINOR_VERSION}.${AUTOMATION_PATCH_VERSION} )

# -- Output directory locations ------------------------------------------------
set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib )
set( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib )
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} )
set( AUTOMATION_THIRD_PARTY ${CMAKE_BINARY_DIR}/ThirdParty )

# -- Setup project dependencies ------------------------------------------------
set_directory_properties(PROPERTIES EP_PREFIX ${AUTOMATION_THIRD_PARTY})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)
include(ExternalProject)

# -- Setup testing dependencies ------------------------------------------------
if( CMAKE_BUILD_TYPE STREQUAL "Lint" )
  set( CMAKE_EXPORT_COMPILE_COMMANDS ON )
else()
  enable_testing()
  include( googletest )
  add_subdirectory( test )
endif()

# -- Enable Code Coverage  -----------------------------------------------------
if( CMAKE_BUILD_TYPE STREQUAL "Coverage" )
  include( CodeCoverage )
  set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage" )
  FIND_PROGRAM( PYTHON_EXECUTABLE python )
  setup_target_for_coverage( coverage ctest coverage )
endif()

# -- Process all subdirectories ------------------------------------------------
add_subdirectory( src )

