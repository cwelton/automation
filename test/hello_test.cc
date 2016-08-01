/** 
 * hello_test.cc
 *
 *   Demonstrates integration of googletest framework
 *
 * Copyright 2016 Caleb Welton
 **/

#include <iostream>

#include "include/awesome.h"
#include "gtest/gtest.h"

namespace AutomationTest {

class TestFixture : public ::testing::Test {
 protected:
    virtual void SetUp() {}
    virtual void TearDown() {}
};

TEST_F(TestFixture, ExampleTest) {
    // this use of auto is here primary to show that we are
    // successfully building with C++11 support.
    auto i = do_something_awesome("unit_test");
    EXPECT_EQ(0, i);
}

}  // namespace AutomationTest
