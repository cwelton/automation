
file(GLOB TEST_SRC_FILES ${PROJECT_SOURCE_DIR}/test/*.cc)

add_executable(runUnitTests ${TEST_SRC_FILES})

add_dependencies(runUnitTests googletest)

target_link_libraries(runUnitTests ${PROJECT_NAME} gtest gtest_main pthread)

add_test(unit_tests ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/runUnitTests)

