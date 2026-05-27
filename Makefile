IMAGE_NAME := pre-commit
CACHE_VOLUME := pre-commit-cache
DOCKER_RUN := docker run --rm -v "$$(pwd):/src" -v $(CACHE_VOLUME):/root/.cache/pre-commit -w /src

.PHONY: all build run shell test clean

all: build

build:
	docker build -t $(IMAGE_NAME) .

run:
	$(DOCKER_RUN) $(IMAGE_NAME) run --all-files

test:
	$(DOCKER_RUN) $(IMAGE_NAME) --version

shell:
	docker run --rm -it -v "$$(pwd):/src" -v $(CACHE_VOLUME):/root/.cache/pre-commit -w /src --entrypoint /bin/bash $(IMAGE_NAME)

clean:
	docker rmi $(IMAGE_NAME) 2>/dev/null || true
	docker volume rm $(CACHE_VOLUME) 2>/dev/null || true
