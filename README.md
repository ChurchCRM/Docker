# Docker ChurchCRM

This is the Docker Installation of ChurchCRM. This image is currently using the latest release of ChurchCRM. It is installed on Alpine Linux, Apache, PHP7 & is using MariaDB in a separate Alpine container.

## How To Use

There are two ways to get this up and running. Starting the container through **``docker run``** or building it with the **``docker-compose.yml``** file.

### Starting the Container

Example:

You can start MariaDB first with the following command. Make sure to **change the passwords** to something more secure.

``docker run --name crm-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-password -e MARIADB_DATABASE=churchcrm -e MARIADB_USER=churchcrm -e MARIADB_PASSWORD=my-secret-pw -d nimmis/alpine-mariadb``

Then start the ChurchCRM container:

``docker run --name churchcrm -p 80:80 -p 443:443 --link crm-mariadb -d churchcrm/crm``

<img src="https://github.com/ChurchCRM/Docker/blob/master/include/Installation.jpg" width="600">

### Building with Docker-Compose

You can also download the Github repository and run ``docker-compose build`` and ``docker-compose up`` from the project folder. **Change Passwords, Ports, etc. in that file before building**.

## Up and Running with ChurchCRM

Once up and running, go to your website and fill in the database username and password that you set up in the commands above or in the docker-compose file. Use **``crm-mariadb``** as the **database host**. Once set up you can use the default username of ``admin`` and password of ``changeme`` to log in.

<img src="https://github.com/ChurchCRM/Docker/blob/master/include/Login.jpg" width="400">
