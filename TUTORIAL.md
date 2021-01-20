# Tutorial

Start the `docker-compose.yml`:
```
version: '3.8'
```

Add *mysql* service:
```
services:
  mysql:
    image: mysql:latest
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
    ports:
      - "3306:3306"
```

Make the storage for *mysql* persistent:
```
services:
  mysql:
    ...
    volumes:
      - mysql:/var/lib/mysql
volumes:
  mysql:
```

Add *phpmyadmin* service to control mysql and connect the both:
```
services:
  ...
  phpmyadmin:
    image: phpmyadmin:latest
    environment:
      PMA_HOST: "mysql"
      PMA_USER: "root"
    ports:
      - "8080:80"
``` 

Add *drupal* service:
```
services:
  ...
  drupal:
    image: drupal:7-apache
    ports:
      - "80:80"
    volumes:
      - drupal:/var/www/html
  ...
volumes:
  ...
  drupal:
```

Create nginx https proxy:
```
services:
  ...
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "${PWD}/nginx:/etc/nginx/conf.d"
      - "${PWD}/certs:/opt/certs"
```

Create custom network topologies by defining networks:
```
services:
...
  nginx:
    networks:
      - www_network
...
  drupal:
    networks:
      - www_network
      - db_network
...
  mysql:
    networks:
      - db_network
...
  phpmyadmin:
    networks:
      - www_network
      - db_network
```

You can specify which sql scripts run at mysql startup:
```
  mysql:
    volumes:
      - "${PWD}/mysql/init-drupal.sql:/docker-entrypoint-initdb.d/init-drupal.sql"
```

Write a `Dockerfile` to embed nginx conf insided docker container:
```
  nginx:
    build: ./nginx
```

Add secrets:
```
services:
  mysql:
    environment:
      MYSQL_ROOT_PASSWORD_FILE: "/run/secrets/mysql_root_password"
    secrets:
      - mysql_root_password
  ...
  phpmyadmin:
    environment:
      PMA_PASSWORD_FILE: "/run/secrets/mysql_root_password"
    secrets:
      - mysql_root_password
secrets:
  mysql_root_password:
    external: true
```

