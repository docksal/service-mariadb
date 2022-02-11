-include env_make

IMAGE ?= docksal/mariadb
UPSTREAM_IMAGE ?= mariadb
VERSION ?= 10.6
BUILD_TAG ?= build-$(VERSION)

NAME = docksal-mariadb-$(VERSION)

MYSQL_ROOT_PASSWORD = root
MYSQL_USER = user
MYSQL_PASSWORD = user
MYSQL_DATABASE = default

ENV = -e MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) -e MYSQL_USER=$(MYSQL_USER) -e MYSQL_PASSWORD=$(MYSQL_PASSWORD) -e MYSQL_DATABASE=$(MYSQL_DATABASE) -e VERSION=$(VERSION)

.EXPORT_ALL_VARIABLES:

.PHONY: build test push shell run start stop logs clean release

build:
	docker build -t $(IMAGE):$(BUILD_TAG) --build-arg UPSTREAM_IMAGE=$(UPSTREAM_IMAGE) --build-arg VERSION=$(VERSION) .

test:
	IMAGE=$(IMAGE) BUILD_TAG=$(BUILD_TAG) NAME=$(NAME) VERSION=$(VERSION) ./tests/test.bats

push:
	docker push $(IMAGE):$(BUILD_TAG)

shell: clean
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(IMAGE):$(BUILD_TAG) /bin/bash

run: clean
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(IMAGE):$(BUILD_TAG)

start: clean
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(IMAGE):$(BUILD_TAG)

exec:
	docker exec $(NAME) /bin/bash -c "$(CMD)"

mysql-query:
	# Usage: make mysql-query QUERY='SHOW DATABASES;'
	docker exec $(NAME) bash -c "mysql --host=localhost --user=root --password=$(MYSQL_ROOT_PASSWORD) -e '$(QUERY)'"

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	docker rm -f $(NAME) >/dev/null 2>&1 || true

tags:
	@.github/scripts/docker-tags.sh

default: build
