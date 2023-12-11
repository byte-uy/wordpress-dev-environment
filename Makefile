.PHONY: build clean clean-containers clean-images test stop

build:
	docker build -t website .

clean-containers:
	- docker kill $$(docker ps -q)
	- docker rm $$(docker ps -a -q)

clean-images:
	- docker rmi $$(docker images -q)

clean:
	$(MAKE) clean-containers
	$(MAKE) clean-images

run:
	docker run -d -p 8080:80 -v ./wp-content:/var/www/html/wp-content --name website-container website 
	docker exec -ti website-container /bin/bash

stop:
	docker stop website-container

start:
	docker start website-container
	docker exec -ti website-container /bin/bash
