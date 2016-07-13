.PHONY: docker

all: docker

docker:
	@echo Building Docker Image
	docker build -t=automation .

	@echo "------------------------------------------------------------"
	@echo Run Docker image with:
	@echo '    docker run -i -t -v `pwd`/env:/home/build automation /bin/bash'

