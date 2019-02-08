# MariaDB Docker images for Docksal

Docksal MariaDB images are derived from the stock `mariab` images from Docker Hub with a few adjustments (see Features).  

We include and enable user defined overrides via a settings file. 

This image(s) is part of the [Docksal](http://docksal.io) image library.

## Features

- Better default settings (see `default.cnf`)
- Ability to pass additional settings via a file mounted into the container
  - User defined MySQL settings are expected in `/var/www/.docksal/etc/mysql/my.cnf` in the container.
- Running a startup script as root
  - Scripts should be placed in the `/docker-entrypoint.d/` folder
- Docker heathcheck support

## Versions

- `docksal/mariabdb:5.5`
- `docksal/mariabdb:10.0`
- `docksal/mariabdb:10.1`
- `docksal/mariabdb:10.2`
- `docksal/mariabdb:10.3`, `docksal/mariadb:latest`
