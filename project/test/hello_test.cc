#include <iostream>
#include "gtest/gtest.h"

namespace AutomationTest {

class TestFixture : public ::testing::Test {
protected:
	virtual void SetUp() {}
	virtual void TearDown() {}
};

TEST_F(TestFixture, ExampleTest) {
	int i = 0;
    EXPECT_EQ(0, i);
}

} // namespace AutomationTest
