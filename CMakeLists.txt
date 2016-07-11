cmake_minimum_required (VERSION 3.1 FATAL_ERROR)
project( automation )

# -- build variables -----------------------------------------------------------
set( CMAKE_CXX_FLAGS "-std=c++14 -pedantic -Wall -Werror" )
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

# -- Process all subdirectories ------------------------------------------------
add_subdirectory( src )

# -- Setup testing dependencies ------------------------------------------------
enable_testing()
include( googletest )
add_subdirectory( test )

  

