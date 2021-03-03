.PHONY: latest native

all: latest native

latest: Dockerfile
	docker buildx build -f Dockerfile . -t nathanhowell/parquet-tools:latest

native: Dockerfile.native
	docker buildx build -f Dockerfile.native . -t nathanhowell/parquet-tools:native --target native
