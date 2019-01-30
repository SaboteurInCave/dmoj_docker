FROM ubuntu:latest
MAINTAINER saboteurinacave@gmail.com

ENV PYTHONIOENCODING=utf-8

# os dependencies
RUN apt update -qqy && apt install locales git gcc g++ make python python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev gettext curl  -qqy && \
apt install nodejs -qqy && \
apt install npm -qqy && \
apt install mariadb-server libmysqlclient-dev -qqy && \
apt install nginx -qqy && \
apt install supervisor -qqy && \
apt clean

# npm dependencies
RUN npm install -g sass pleeease-cli && npm install qu ws simplesets

# create workdir
RUN mkdir -p /opt/dmoj
WORKDIR /opt/dmoj

# clone site and instal python dependencies
RUN git clone https://github.com/DMOJ/site.git
RUN cd site && git submodule init && git submodule update && \
pip install -r requirements.txt && pip install 'mysqlclient < 1.4' && pip install uwsgi && rm -rf ~/.cache
# important note: on mysqlclient==1.4 everything is broken!

# copy site settings
COPY local_settings.py site/dmoj
COPY uwsgi.ini site/
COPY config.js site/websocket

WORKDIR /opt/dmoj/site

#  make assets and other stuff
RUN ./make_style.sh

# static files and localization
RUN echo yes | python manage.py collectstatic && \
python manage.py compilemessages && \
python manage.py compilejsi18n

COPY dataLoading.bash .
RUN chmod u+x dataLoading.bash

# copy nginx configiration
COPY nginx.conf /etc/nginx/sites-available/nginx.conf
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

# create problems volume
RUN mkdir -p /opt/problems

# Volumes creation
VOLUME "/opt/problems"

# supervisor managment
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]
