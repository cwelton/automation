file( GLOB SOURCES *.cc )
list( REMOVE_ITEM SOURCES "main.cc" )

add_library( ${PROJECT_NAME} STATIC ${SOURCES} )

add_executable( hello main.cc )

target_link_libraries( hello ${PROJECT_NAME} )
