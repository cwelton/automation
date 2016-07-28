#!/bin/bash

apt-get update
apt-get install -y build-essential cmake lcov
apt-get install -y software-properties-common python-software-properties
apt-get install -y python python-dev python-pip
pip install --upgrade pip
pip install gcovr

wget --quiet https://github.com/oclint/oclint/releases/download/v0.10.3/oclint-0.10.3-x86_64-linux-3.13.0-74-generic.tar.gz -O /tmp/oclint-0.10.3.tar.gz
tar -xzf /tmp/oclint-0.10.3.tar.gz
ln -s oclint-0.10.3 oclint
