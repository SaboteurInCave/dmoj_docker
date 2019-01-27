FROM ubuntu:latest
MAINTAINER saboteurinacave@gmail.com

# os dependencies
RUN apt update -qqy && apt install git gcc g++ make python-dev libxml2-dev libxslt1-dev zlib1g-dev gettext curl python3 python3-dev -qqy && \
apt install nodejs -qqy && \
apt install npm -qqy && \
apt install mariadb-server libmysqlclient-dev -qqy && \
apt install nginx -qqy

# npm dependencies
RUN npm install -g sass pleeease-cli

# create workdir
RUN mkdir -p /opt/dmoj
WORKDIR /opt/dmoj

# clone site and instal python dependencies
RUN git clone https://github.com/DMOJ/site.git
RUN git submodule site/init && RUN git submodule site/update
RUN pip install -r requirements.txt && pip install mysqlclient

#  make assets
RUN ./site/make_style.sh




