VERSION=0.1
REPOSITORY?=raelga/hello-world-nginx
TAG=v$(VERSION)

all: build test

build:
	@echo "Building image:"
	docker build -t $(REPOSITORY):$(TAG) -f Dockerfile ctx

push:
	@echo "Pushing image:"
	docker push $(REPOSITORY):$(TAG)

test:
	@echo "Running container:"
	docker run --rm -p 8080:8080 $(REPOSITORY):$(TAG)