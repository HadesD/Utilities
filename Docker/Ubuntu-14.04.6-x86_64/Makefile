# make v=/xxx exec

IMAGE_NAME='darkhades/ubuntu:14.04.6-x86_64'

build:
	docker build -t ${IMAGE_NAME} -f Dockerfile .

exec:
	docker run --rm -it \
		--workdir /srv \
		-v ${v}:/srv/app
		--name ubuntu-14_04_6-x86_64 \
		${IMAGE_NAME} zsh

