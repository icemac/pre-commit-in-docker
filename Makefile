IMAGE_NAME := pre-commit
CACHE_VOLUME := pre-commit-cache

.PHONY: build run shell clean

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run --rm \
		-v "$$(pwd):/src" \
		-v $(CACHE_VOLUME):/root/.cache/pre-commit \
		-w /src \
		$(IMAGE_NAME) run --all-files

shell:
	docker run --rm -it \
		-v "$$(pwd):/src" \
		-v $(CACHE_VOLUME):/root/.cache/pre-commit \
		-w /src \
		--entrypoint /bin/bash \
		$(IMAGE_NAME)

clean:
	docker rmi $(IMAGE_NAME) 2>/dev/null || true
	docker volume rm $(CACHE_VOLUME) 2>/dev/null || true
