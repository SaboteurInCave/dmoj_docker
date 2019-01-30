# DMOJ Docker image

## General description

docker-compose.yml contains inital settings for three images:

1. _dmoj_ - web interface with nginx and django + judger. 
This image has __problems__ volume, which stores a problem data. 
If you want to view logs, please enter the container (`docker exec -it dmoj /bin/bash`) and find the __/tmp__ directory inside of container. 
2. _dmoj_db_ - mariadb instance. This image hasn't got any external ports, only services from project have access to it.
The __db__ volume stores a persistent data from database, so it is not recommended to remove this folder at all. 
The __sql__ volume contains the sql initialization file for first startup of the mariadb container.
3. _dmoj_judge_ - instance of judge component. This container and _dmoj_ has a shared __problems__ volume.

If you need to change ports, please, change the first port in mapping, 
because the mapping is based on the following scheme: `<HOST:CONTAINER>`.


## Build instruction

First, you need to install `docker` and `docker-compose` on your system.
Secondly, you need to create _.env_db_ and _.env_judge_ env files with the following variables:

.env_judge:

    SERVER_HOST=dmoj
    JUDGE_NAME=<place_name_for_site>
    JUDGE_KEY=<place_key_for_site>

.env_db:

    MYSQL_ROOT_PASSWORD=<ROOT_PASSWORD>
    MYSQL_DATABASE=test
    MYSQL_USER=dmoj
    MYSQL_PASSWORD=<USER_DMOJ_PASSWORD>

 
If you change _MYSQL_PASSWORD_, please copy that value into _sql/init.sql_ for the password and for _local_setting.py_:

init.sql:

    CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
    GRANT ALL PRIVILEGES ON dmoj.* to 'dmoj' IDENTIFIED BY <YOUR_NEW_PASSWORD_HERE>


local_settings.py:

    DATABASES = {
         'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': 'dmoj',
            'USER': 'dmoj',
            'PASSWORD': <YOUR_NEW_PASSWORD_HERE>,
            'HOST': 'dmoj_db',
            'OPTIONS': {
                'charset': 'utf8',
                'sql_mode': 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION',
            },
        }
    }

Also, you can edit the _local_settings.py_ or _nginx.conf_ for another purposes, of course!

In the end of changes, just type `docker-compose up --build -d` and wait for the ending of building process.

If everything is OK (from the output and by using `docker-compose logs`), you need to initiate the database migration process and superuser creation:

1. Enter the __dmoj__ container: `docker exec -it dmoj /bin/bash`
2. Run init script: `./dataLoading.bash` and follow the commands.
3. Exit the container (`Ctrl+D` for example)
4. Restart the whole dockerized project: `docker-compose restart`

After that, enter the site via browser, sign in as root user and register judge component with data from `.env_judge` (name and key).

If everything done correctly, you can use the system - congratulations!
