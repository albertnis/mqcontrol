FROM docker:19.03.8

ADD entrypoint.sh /entrypoint.sh

COPY config.json /root/.docker

ENV DOCKER_BUILDKIT=1
ENTRYPOINT [ "/entrypoint.sh" ] 
