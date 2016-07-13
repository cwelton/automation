
add_executable(runUnitTests hello_test.cc)

target_link_libraries(runUnitTests gtest gtest_main pthread)

add_test(unit_tests ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/runUnitTests)

