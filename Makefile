.PHONY: build clean test

build:
	docker build -t website .

clean:
	@CONTAINERS=$$(docker ps -a -q); \
	if [ -n "$$CONTAINERS" ]; then \
		docker kill $$CONTAINERS; \
		docker rm $$CONTAINERS; \
	fi
	@IMAGES=$$(docker images -q); \
	if [ -n "$$IMAGES" ]; then \
		docker rmi $$IMAGES; \
	fi

test:
	docker run -d -p 8080:80 --name website-container website 
	docker exec -ti website-container /bin/bash
