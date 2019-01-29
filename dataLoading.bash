#!/bin/bash

python manage.py migrate
python manage.py loaddata navbar
python manage.py loaddata language_small
python manage.py createsuperuser
