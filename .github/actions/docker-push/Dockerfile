FROM docker:19.03.8

ADD entrypoint.sh /entrypoint.sh

ENV DOCKER_BUILDKIT=1

RUN docker manifest
ENTRYPOINT [ "/entrypoint.sh" ] 
