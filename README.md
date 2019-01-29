# DMOJ Docker image

## local_settings.py

Need to change password and allowed_host

## setting root

`docker exec -it dmoj /bin/bash`

`(in_container) cd /opt/dmoj/site`

`(in_container) python manage.py createsuperuser` # this command is actually creates the superuser
