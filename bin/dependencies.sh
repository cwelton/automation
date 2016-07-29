#!/bin/bash
set -e

AG_FLAGS='-yq --no-install-suggests --no-install-recommends --force-yes'

sudo -E apt-get -yq update
sudo -E apt-get ${AG_FLAGS} install software-properties-common python-software-properties
sudo -E apt-add-repository -y "ppa:ubuntu-toolchain-r/test"
sudo -E apt-get -yq update
sudo -E apt-get ${AG_FLAGS} install build-essential gcc-4.9 g++-4.9 lcov python python-dev python-pip cmake
sudo -H pip install --upgrade pip
sudo -H pip install gcovr

wget --quiet http://github.com/oclint/oclint/releases/download/v0.10.3/oclint-0.10.3-x86_64-linux-3.13.0-74-generic.tar.gz -O /tmp/oclint-0.10.3.tar.gz
tar -C ${HOME} -xzf /tmp/oclint-0.10.3.tar.gz
ln -s ${HOME}/oclint-0.10.3 ${HOME}/oclint
