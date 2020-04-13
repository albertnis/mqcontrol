FROM docker:19.03.8

ADD entrypoint.sh /entrypoint.sh

ADD config.json /root/.docker/config.json

ENV DOCKER_BUILDKIT=1
# RUN "cat /root/.docker/config.json"
# RUN "cat ~/.docker/config.json"

RUN docker manifest
ENTRYPOINT [ "/entrypoint.sh" ] 
