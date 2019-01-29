-include env_make

VERSION ?= 10.3
TAG ?= $(VERSION)
REPO ?= zabolotny/mariadb

NAME = docksal-mariadb-$(VERSION)

MYSQL_ROOT_PASSWORD = root
MYSQL_USER = user
MYSQL_PASSWORD = user
MYSQL_DATABASE = default

ENV = -e MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) -e MYSQL_USER=$(MYSQL_USER) -e MYSQL_PASSWORD=$(MYSQL_PASSWORD) -e MYSQL_DATABASE=$(MYSQL_DATABASE) -e VERSION=$(VERSION)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build test push shell run start stop logs clean release

build:
	docker build -t $(REPO):$(TAG) --build-arg VERSION=$(VERSION) .

test:
	IMAGE=$(REPO):$(TAG) NAME=$(NAME) VERSION=$(VERSION) bats ./tests/test.bats

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

start: clean
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

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

release: build push

default: build
