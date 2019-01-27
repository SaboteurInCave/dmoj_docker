FROM ubuntu:latest
MAINTAINER saboteurinacave@gmail.com

# os dependencies
RUN apt update -qqy && apt install git gcc g++ make python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev gettext curl  -qqy && \
apt install nodejs -qqy && \
apt install npm -qqy && \
apt install mariadb-server libmysqlclient-dev -qqy && \
apt install nginx -qqy && \
apt install supervisor -qqy

# npm dependencies
RUN npm install -g sass pleeease-cli

# database initialization
RUN service mysql start && \
mysql -uroot --execute="CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci; GRANT ALL PRIVILEGES ON dmoj.* to 'dmoj'@'localhost' IDENTIFIED BY 'qwerty'"

# create workdir
RUN mkdir -p /opt/dmoj
WORKDIR /opt/dmoj

# clone site and instal python dependencies
RUN git clone https://github.com/DMOJ/site.git
RUN cd site && git submodule init && git submodule update && \
pip install -r requirements.txt && pip install mysqlclient

RUN python --version

# copy site settings
COPY local_settings.py site/dmoj

#  make assets and other stuff
RUN ./site/make_style.sh

RUN cd site && \
service mysql start && \
python manage.py collectstatic && \
python manage.py compilemessages && \
python manage.py compilejsi18n && \
python manage.py migrate && \
python manage.py loaddata navbar && \
python manage.py loaddata language_small && \
python manage.py loaddata demo && \
python manage.py createsuperuser

# supervisor managment
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]

#CMD ['python', 'manage.py', 'runserver', '0.0.0.0:8000']


