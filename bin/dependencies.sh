#!/bin/bash
set -e

AG_FLAGS='-yq --no-install-suggests --no-install-recommends --force-yes'

sudo -E apt-get -yq update
sudo -E apt-get ${AG_FLAGS} install software-properties-common python-software-properties
sudo -E apt-add-repository -y "ppa:ubuntu-toolchain-r/test"
sudo -E apt-get -yq update
sudo -E apt-get ${AG_FLAGS} install gcc-4.9 g++-4.9 ggcov lcov cmake ruby rubygems-integration
sudo -E update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 50
sudo -E update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50
sudo -E update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-4.9 50

if [ -z ${TRAVIS} ]; then
	sudo gem install coveralls-lcov
else
    gem install coveralls-lcov
fi

# Python environment
sudo -E apt-get ${AG_FLAGS} install python2.7 python2.7-dev python-pip
sudo -H pip install --upgrade pip
sudo -H pip install cpplint
sudo -H pip install networkx
which pip
pip show networkx

wget --quiet http://github.com/oclint/oclint/releases/download/v0.10.3/oclint-0.10.3-x86_64-linux-3.13.0-74-generic.tar.gz -O /tmp/oclint-0.10.3.tar.gz
tar -C ${HOME} -xzf /tmp/oclint-0.10.3.tar.gz
ln -s ${HOME}/oclint-0.10.3 ${HOME}/oclint

