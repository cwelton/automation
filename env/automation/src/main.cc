#include <iostream>


int do_something_awesome(std::string output) {
	std::cout << output << std::endl;
	return 0;
}

int main() 
{
	return do_something_awesome("hello world: ");
}
