# make v=/xxx exec

CONTAINER_HOST_NAME=ubuntu-14_04_6-x86_64
IMAGE_NAME='darkhades/ubuntu:14.04.6-x86_64'
CONTAINER_WORKDIR='/srv/app'

build:
	docker build -t ${IMAGE_NAME} -f Dockerfile .

exec:
	docker run --rm -it \
		--workdir ${CONTAINER_WORKDIR} \
		-v ${v}:${CONTAINER_WORKDIR} \
		--name ${CONTAINER_HOST_NAME} \
		--hostname ${CONTAINER_HOST_NAME} \
		${IMAGE_NAME} zsh

