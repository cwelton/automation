#include <iostream>

#include "awesome.h"
#include "gtest/gtest.h"

namespace AutomationTest {

class TestFixture : public ::testing::Test {
protected:
	virtual void SetUp() {}
	virtual void TearDown() {}
};

TEST_F(TestFixture, ExampleTest) {
	int i = do_something_awesome("unit_test");
    EXPECT_EQ(0, i);
}

} // namespace AutomationTest
