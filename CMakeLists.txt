cmake_minimum_required (VERSION 2.8.8 FATAL_ERROR)
project( automation )

# -- build variables -----------------------------------------------------------
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pedantic -Wall -Werror -Wextra" )
set( PROJECT_VERSION_MAJOR 0 )
set( PROJECT_VERSION_MINOR 1 )
set( PROJECT_VERSION_PATCH 0 )
set( PROJECT_VERSION ${PROJECT_MAJOR_VERSION}.${PROJECT_MINOR_VERSION}.${PROJECT_PATCH_VERSION} )

# -- Output directory locations ------------------------------------------------
set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib )
set( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib )
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} )
set( PROJECT_THIRD_PARTY ${CMAKE_BINARY_DIR}/ThirdParty )

# -- Setup project dependencies ------------------------------------------------
set_directory_properties(PROPERTIES EP_PREFIX ${PROJECT_THIRD_PARTY})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)
include(ExternalProject)

# -- Enable Code Coverage  -----------------------------------------------------
if(COVERAGE)
  include( CodeCoverage )
  set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage" )
  setup_target_for_coverage( coverage ctest coverage )
endif()

# -- Setup include directory location ------------------------------------------
include_directories( include )

# -- Setup testing dependencies ------------------------------------------------
set( CMAKE_EXPORT_COMPILE_COMMANDS ON )
enable_testing()
include( googletest )
add_subdirectory( test )

  
# -- Process all subdirectories ------------------------------------------------
add_subdirectory( src )

