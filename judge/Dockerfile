FROM ubuntu:latest
MAINTAINER saboteurinacave@gmail.com

# docker file was taken from https://hub.docker.com/r/dmoj/judge-base with some improvements

RUN groupadd -r judge && useradd -r -g judge judge

# ubuntu requirements
RUN apt update -qqy && \
apt install git python python2.7-dev python3 python-pip gcc g++ fpc wget file build-essential llvm clang -qqy && \
apt clean

# install python requirements
RUN pip install pyyaml watchdog cython ansi2html termcolor && rm -rf ~/.cache

# create problems directory
RUN mkdir -p /problems

# clone judge system
RUN git clone https://github.com/DMOJ/judge
WORKDIR /judge

# clone config file
RUN mkdir -p config
COPY judge.yml config

RUN env DMOJ_REDIST=1 python setup.py develop && rm -rf build/

USER judge
