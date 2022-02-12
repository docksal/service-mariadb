# Load test variables
-include tests/env_make

# Allow using a different docker binary
DOCKER ?= docker

# Force BuildKit mode for builds
# See https://docs.docker.com/buildx/working-with-buildx/
DOCKER_BUILDKIT=1

IMAGE ?= docksal/mariadb
VERSION ?= 10.6
UPSTREAM_IMAGE ?= mariadb:$(VERSION)
BUILD_IMAGE_TAG ?= $(IMAGE):$(VERSION)-build
NAME = docksal-mariadb-$(VERSION)

MYSQL_ROOT_PASSWORD = root
MYSQL_USER = user
MYSQL_PASSWORD = user
MYSQL_DATABASE = default

ENV = -e MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) -e MYSQL_USER=$(MYSQL_USER) -e MYSQL_PASSWORD=$(MYSQL_PASSWORD) -e MYSQL_DATABASE=$(MYSQL_DATABASE) -e VERSION=$(VERSION)

# Make it possible to pass arguments to Makefile from command line
# https://stackoverflow.com/a/6273809/1826109
ARGS = $(filter-out $@,$(MAKECMDGOALS))

.EXPORT_ALL_VARIABLES:

.PHONY: build test push shell run start stop logs clean

default: build

build:
	$(DOCKER) build -t $(BUILD_IMAGE_TAG) --build-arg UPSTREAM_IMAGE=$(UPSTREAM_IMAGE) --build-arg VERSION=$(VERSION) .

test:
	IMAGE=$(BUILD_IMAGE_TAG) NAME=$(NAME) VERSION=$(VERSION) ./tests/test.bats

push:
	$(DOCKER) push $(BUILD_IMAGE_TAG)

shell: clean
	$(DOCKER) run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(BUILD_IMAGE_TAG) /bin/bash

run: clean
	$(DOCKER) run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(BUILD_IMAGE_TAG)

start: clean
	$(DOCKER) run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(BUILD_IMAGE_TAG)

exec:
	$(DOCKER) exec $(NAME) /bin/bash -c "$(CMD)"

mysql-query:
	# Usage: make mysql-query QUERY='SHOW DATABASES;'
	$(DOCKER) exec $(NAME) bash -c "mysql --host=localhost --user=root --password=$(MYSQL_ROOT_PASSWORD) -e '$(QUERY)'"

stop:
	$(DOCKER) stop $(NAME)

logs:
	$(DOCKER) logs $(NAME)

logs-follow:
	$(DOCKER) logs -f $(NAME)

debug: build start logs-follow

clean:
	$(DOCKER) rm -vf $(NAME) || true

# Make it possible to pass arguments to Makefile from command line
# https://stackoverflow.com/a/6273809/1826109
%:
	@:
