# -- Usage to build and run development image --------------------------------
# docker build -t=automation .
# docker run -i -t -v `pwd`/env:/home/build -v /bin/bash

# -- Install Dependencies and tools ------------------------------------------
FROM ubuntu:xenial
MAINTAINER Caleb Welton <cwelton@apache.org>
RUN apt-get update

# -- Install Dependencies and tools ------------------------------------------
RUN apt-get install -y sudo man wget
RUN apt-get install -y build-essential cmake lcov
RUN apt-get install -y python python-dev python-pip
RUN apt-get install -y git emacs vim
RUN pip install --upgrade pip
RUN pip install gcovr

# -- static code analysis tool oclint:   http://oclint.org/
WORKDIR /opt
RUN wget https://github.com/oclint/oclint/releases/download/v0.10.3/oclint-0.10.3-x86_64-linux-3.13.0-74-generic.tar.gz
RUN tar -xzf oclint-0.10.3-x86_64-linux-3.13.0-74-generic.tar.gz && rm oclint-0.10.3-x86_64-linux-3.13.0-74-generic.tar.gz
RUN ln -s oclint-0.10.3 oclint

# -- Setup environment -------------------------------------------------------
RUN useradd -ms /bin/bash build
RUN usermod -a -G sudo build
RUN usermod -a -G staff build
USER build
WORKDIR /home/build
