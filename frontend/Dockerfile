FROM ubuntu:latest
MAINTAINER saboteurinacave@gmail.com

# dependensies
RUN apt update -qqy && apt install git gcc g++ make python-dev libxml2-dev libxslt1-dev zlib1g-dev gettext curl python3 python3-dev -qqy && \
apt install nodejs -qqy && \
apt install npm -qqy && \
apt install mariadb-server libmysqlclient-dev -qqy && \
apt install nginx -qqy

RUN npm install -g sass pleeease-cli

# create workdir

RUN mkdir -p /opt/dmoj
WORKDIR /opt/dmoj

# clone site and make assets
RUN git clone https://github.com/DMOJ/site.git && cd site/
RUN ./make_style.sh
