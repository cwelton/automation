cmake_minimum_required (VERSION 2.8)
project (automation)

# -- build variables -----------------------------------------------------------
set( AUTOMATION_VERSION_MAJOR 0 )
set( AUTOMATION_VERSION_MINOR 1 )
set( AUTOMATION_VERSION_PATCH 0 )
set( AUTOMATION_VERSION ${AUTOMATION_MAJOR_VERSION}.${AUTOMATION_MINOR_VERSION}.${AUTOMATION_PATCH_VERSION} )

# -- Output directory locations ------------------------------------------------
set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# -- Process all subdirectories ------------------------------------------------
add_subdirectory( src )

