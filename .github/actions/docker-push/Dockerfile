FROM docker:19.03.8

ADD entrypoint.sh /entrypoint.sh

COPY config.json /root/.docker/

ENV DOCKER_BUILDKIT=1
RUN "cat /root/.docker/config.json"
RUN "cat ~/.docker/config.json"

RUN docker manifest
ENTRYPOINT [ "/entrypoint.sh" ] 
