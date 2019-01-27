docker exec dmoj --env-file=.env mysql -uroot --execute='CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci; GRANT ALL PRIVILEGES ON dmoj.* to 'dmoj'@'localhost' IDENTIFIED BY "${DATABASE_PASSWORD}"'

docker exec dmoj --env-file=.env /bin/sh -c  cd /opt/dmoj/site;
python manage.py collectstatic;
python manage.py compilemessages;
python manage.py compilejsi18n
python manage.py migrate;
python manage.py loaddata navbar;
python manage.py loaddata language_small;
python manage.py loaddata demo;
python manage.py createsuperuser