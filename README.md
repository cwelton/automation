automation [![Build Status](https://travis-ci.org/cwelton/automation.svg?branch=master)](https://travis-ci.org/cwelton/automation) [![Coverage Status](https://coveralls.io/repos/github/cwelton/automation/badge.svg?branch=master)](https://coveralls.io/github/cwelton/automation?branch=master)
==========

Small hello world application to test travis integration.

Goals
----
* Demonstrate building and running within travis-ci
* Demonstrate a local environment running in Vagrant
* Minimize delta between local Vagrant and travis environments without duplicating dependency logic
* Demonstrate C++ build with a modernish c++ compiler (C++11)
* Demonstrate integration with google test as a dependency managed by cmake
* Demonstrate lint integration including checks for cyclomatic complexity using oclint and cpplint
* Demonstrate code coverage collection via gcov and lcov
* Demonstrate code coverage reporting and integration with coveralls.io


Demonstrate building and running within travis-ci
----

Travis-ci (https://travis-ci.org/) provides a containerized build environment that can be run on every 
checkin to the source and perform validation checks to ensure that the code is kept in an operational form.

The primary control mechanism for travis is the `.travis.yml` file which provides the key setup and running
instructions for the travis build.

For all the benefits that Travis brings it can be frustrating to deal with at times because of lack to 
interactive shell for the build process. 

In order to launch a travis build all that is required is enabling integration in the github project and then
a simple `git push`, after that everything runs automatically.


Demonstrate a local environment running in Vagrant
----

To help mitigate the frustrations of travis having a local interactive build and test environment as close
to that of Travis as possible can be very useful. 

The primary control mechanism for Vagrant (https://www.vagrantup.com/) is the `Vagrantfile` which provides the details of how to initialize
the vagrant environment.

Of particular note is that care was taken to make the Vagrant environment as close as posible to the travis
environment. This includes placing the core project under the `$HOME/gitnamespace/gitproject` directory.  Care
was taken to allow the actual gitnamespace/gitproject to be extracted from the giturl of the project allowing
for easier cut/paste of this Vagrantfile to other projects.

In order to launch vagrant the following commands are necessary:
```
  vagrant up
  vagrant ssh
```

You can tear down and reinitialize the vagrant environment with:
```
  vagrant destroy -f
  vagrant up
```

Despite efforts to keep the Vagrant and Travis environments as similar as possible, there are inevitable differences.
There was once a time that Travis was based on a Vagrant infrastructure and you could use their vagrant boxes directly
allowing for super simple parity, but no longer.  In particular not all enviornment, tooling, and tool versioning is 
guaranteed to be the same between the environments and this may lead to things that work in one environment but not
in the other.

Note: Initially testing was prototyped in Docker, but then I switched to Vagrant due to it being a more
natural integration with the local host OS and it permitted easier construction of a local environment that
closely mimiced the travis environment. Within docker significantly more work was required to setup basic
home directory structures.

The key Vagrant setup specific to initializing Vagrant and not applicable to Travis is encapsulated in the following
block of the `Vagrantfile`:
```
  config.vm.provision "shell", inline: <<-SHELL
     mkdir -p #{target_directory}
     ln -s /vagrant #{target_path}
     sudo -H -u vagrant #{target_path}/bin/dependencies.sh
     echo "cd #{target_path}" >> #{home_dir}/.bashrc
  SHELL
```

Which accomplishes setting up the directory structure for the Vagrant environment in a way that mimics the travis
directory structure.


Minimize delta between local Vagrant and travis environments without duplicating dependency logic
----

Environment setup between both Vagrant and Travis environments has been centralized in `bin/dependencies.sh`.

This is a bit of a compromize, as it would be possible to do the same dependency setup within the `.travis.yml`
file in a more cannonical way, however the benefits of having a single place to record dependencies between
both local and cloud environments seems worth the tradeoff.

Even then there are cases where a single method of installing dependencies does not work well in both platforms.
The example within the project is that ruby gemfiles need to be installed with sudo in vagrant, and need to NOT be
installed with sudo in travis.  This results the following code in `bin/dependencies.sh`:
```
if [ -z ${TRAVIS} ]; then
	sudo gem install coveralls-lcov
else
    gem install coveralls-lcov
fi
```

Net net, is that having the local environment does not mean that the need to debug travis is gone completely,
but it does help with a significant amount of local triage.

Demonstrate C++ build with a modernish c++ compiler (C++11)
----

Travis comes with a variety of tools already installed, however the gcc/clang versions in particular are
several years old, and insufficient when it comes to compiling modern c++ projects, e.g. c++11, or c++14.

To address this we need the following logic in `bin/dependencies.sh`:

```
1  sudo -E apt-get -yq update
2  sudo -E apt-get ${AG_FLAGS} install software-properties-common python-software-properties
3  sudo -E apt-add-repository -y "ppa:ubuntu-toolchain-r/test"
4  sudo -E apt-get -yq update
5  sudo -E apt-get ${AG_FLAGS} install gcc-4.9 g++-4.9 ggcov lcov cmake ruby rubygems-integration
6  sudo -E update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 50
7  sudo -E update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50
8  sudo -E update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-4.9 50
```

The first two lines ensure that apt-add-repository is present, they are only needed in the Vagrant environment
since apt-add-repository already exists in the Travis environment.

Lines 3 and 4 add a repository that has more recent versions of gcc available for download and refreshes the
apt-get directory.

Line 5 adds the core dependencies needed by the project.  The ruby and rubygems-integration are needed for
the code coverage support, described in more detail below.

Lines 6-8 set the default compiler to the newly installed one.  There may be a better way of handling this 
especially if we wish to add support for a build matrix of different compilers in the future.


Demonstrate integration with google test as a dependency managed by cmake
----

Googletest (https://github.com/google/googletest) support is implemented in `cmake/Modules/googletest.cmake`, 
`CMakeLists.txt` and the code under `tests/`.  In particular the key logic is related to the download and 
install of the googletest framework.

Note that `cmake/Modules/CodeCoverage.cmake` also required some specific additions to exclude the gtest framework 
itself from the output of code coverage metrics.

Demonstrate lint integration including checks for cyclomatic complexity using oclint and cpplint
----

Oclint (http://oclint.org/) is a static code analyis tool which provides mechanisms to verify several different
types of issues with code including:
  - High Cyclomatic Complexity
  - unused variables / parameters
  - various bad practices
  - etc
  
  
cpplint (https://pypi.python.org/pypi/cpplint) is a python utility that verifies that code complies with the google c++ style guide (http://google.github.io/styleguide/cppguide.html)
  
The OClint toolchain is a little funky and requires a little extra contortion to employ.  Specifically oclint is driven by a compile_commands.json file which is something that cmake 
can spit out (specifically via `set( CMAKE_EXPORT_COMPILE_COMMANDS ON )`, but the file must be in the root 
directory of the project (it can't be under the cmake build/ directory). This is managed in the `Makefile` by 
copying the compile\_commands.json file out of build/, running the lint, and then removing the
compile\_commands.json file.

If you want to configure oclint's configuration update the `.oclint` file per 
(http://oclint-docs.readthedocs.io/en/stable/howto/rcfile.html), which unfortunately is not super well documented.

OClint is not available as an apt-get dependency, so the installation mechanism in `bin/dependencies.sh` is as 
follows:
```
wget --quiet http://github.com/oclint/oclint/releases/download/v0.10.3/oclint-0.10.3-x86_64-linux-3.13.0-74-generic.tar.gz -O /tmp/oclint-0.10.3.tar.gz
tar -C ${HOME} -xzf /tmp/oclint-0.10.3.tar.gz
ln -s ${HOME}/oclint-0.10.3 ${HOME}/oclint

```

cpplint is configured by the CPPLINT.cfg file. There is some redundancy between cpplint and oclint, 
however both of them provide checks that the other does not.
  * oclint provides important cyclomatic complexity metrics
  * cpplint provides many more style checks


Demonstrate code coverage collection via gcov and lcov
----

Code coverage collection is done with gcov and lcov and is accomplished primarily via configuration within 
cmake. Most of the details can be found under `cmake/Modules/CodeCoverage.cmake` combined with the section
in `CMakeLists.txt` under:
```
if(COVERAGE)
  include( CodeCoverage )
  set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage" )
  setup_target_for_coverage( coverage ctest coverage )
endif()
```

The basic mechanism is:
- call `lcov --zerocounters` to clear out any previous metrics
- run the unit tests
- call `lcov --capture` to digest the results
- call `lcov --remove` to exclude the unit tests themselves, google test, and system code
- call `lcov --summary` to present the coverage summary statistics
- call `genhtml` to generate html output of the coverage results

Demonstrate code coverage reporting and integration with coveralls.io
----

Finally in order to display the code coverage results in a more digestable location we use 
coveralls-lcov (https://github.com/okkez/coveralls-lcov) to publish the lcov results to coveralls.io 
(http://coveralls.io) to allow perusal of the code and display of a coverage banner icon in this readme.

coveralls-lcov itself is a ruby gem, which results in the ruby dependency in `bin/dependencies.sh` and there
is native integration with travis so that you do not need to manually refer to the coveralls token (this makes
it easier to migrate the code between git projects).

Within travis we export the coverage results from the `.travis.yml` file via:
```
  - coveralls-lcov build/coverage/coverage.info
```

Which leverages the `coverage.info` generated by lcov. 


If you want to publish coverage results from Vagrant for some reason you will need to specify the coveralls token:
```
bash$ coveralls-lcov --token "<token for your project>" build/coverage/coverage.info
```

