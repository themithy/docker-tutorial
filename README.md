# Docker tutorial

In this tutorial we will learn the basics of docker and prepare a application
for a deployment in cloud.

## Requirements

Get a Linux machine with Mint or Ubuntu and install docker:
```
sudo apt-get install -y docker.io docker-compose
```

## Http server (simple example)

Here is how we can quickly run a http server:
```
docker run -p 80:80 httpd:latest
```
Now open `http://localhost` in browser and viola!

We can also use the official apache2 image to server some specific content:
```
docker run -p 80:80 -v "${PWD}/html-sample:/usr/local/apache2/htdocs/" httpd:latest
```

The `-p` option makes the docker port visible from the outside world. By
default all docker ports are not exposed.

The `-v` option binds a local directory to the directory that is served by
apache.

The `-d` option lets us run the container in a "detached mode" (in background).

## Mysql server 

We will use the official mysql image (w/o writing own Dockerfile).

```
mysql run -d -e MYSQL_ALLOW_EMPTY_PASSWORD="yes" -p 3306:3306 mysql:latest
```

The `-e` option lets us pass env variables directly to the container. Here the
variable `MYSQL_ALLOW_EMPTY_PASSWORD` allows us to run the server with empty
root password.

Note: `3306` is the default mysql port.

Now we have at least 2 options to connect to the server.

### Connect using mysql-client (Option 1)

Now we can connect to the mysql server from our local machine, by using
`mysql-client` for example. Install `mysql-client` first.
```
sudo apt-get install mysql-client
```

And connect:
```
mysql --host=127.0.0.1 --user=root
```

We instruct mysql to connect to local server, because the `3306` port is
forwarded to the docker container. 

Note: Specifying `localhost` instead of the ip address `127.0.0.1` will make
mysql try to connect using the unix socket, which will not work because
only the TCP/IP port is exposed.

### Open the shell in the docker container (Option 2)

Check the container id via `docker ps` command, and then open the shell:
```
docker exec -it <CONTAINER-ID> bash
```

Now you can connect to mysql server from inside docker container:
```
mysql # no flags required 
```

### Persist data inside container

The data would not be persisted between subsequent docker container runs. To
persist the data we have to use mount docker volume. The volume would be
created for us and managed completely by docker. Add this option to `docker-run`:
`-v tutorial_mysql_vol:/var/lib/mysql`.

```
mysql run -d -e MYSQL_ALLOW_EMPTY_PASSWORD="yes" -p 3306:3306 -v tutorial_mysql_vol:/var/lib/mysql mysql:latest
```

To list all volumes:
```
docker volume ls
```

To remove a volume and start over:
```
docker volume rm tutorial_mysql_vol
```

Note: If you use volumes created later by `docker-compose` remember about the
prefix with current dir name. The name of the volume would be:
`docker-example_tutorial_mysql_vol`.

## Complete application using docker-compose

Now we run an application composed of 3 docker containers: drupal, mysql,
phpmyadmin. The application stack should be specified in `docker-compose.yml`
file.
```
docker-compose -f config/docker-compose.yml up
```

To stop application:
```
docker-compose -f config/docker-compose.yml down
```

Check `http://localhost` in the browser.

The `-d` option runs in detached mode.

The `-f` option allows us to change the compose file, e.g. `-f my-file.yml`.

The `-p` option lets us change the name that will be used as prefix for
containers, networks, or volumes.

## Complete application using Docker Swarm

Deploy the configuration:
```
docker swarm init
docker stack deploy -c config/docker-compose.yml tutorial
```

Delete the deploy:
```
docker stack rm tutorial
```

List services:
```
docker service ls
```

Show logs of a service:
```
docker service logs tutorial_mysql
```

## Own dockerfile

You can create your own docker image by writing a `Dockerfile`.
```
docker build ./debian/ -t tutorial-example
docker run -it tutorial-example
```
You can find a simple example in `./debian/` directory.

## Security remarks

Note: Use this for development only. Do not use it on production!

This tutorial is intended to quickly setup drupal application on LAMP stack for
development. At least do this in production setup:
1. Setup proper password for mysql root user.
2. Do not expose mysql port (3306) to the outside world.
3. Secure access to phpmyadmin (or disable it completely).
4. Generate new certificates.
