FROM docker:19.03.8

RUN apk add --no-cache curl

RUN mkdir -p ~/.docker/cli-plugins \
 && curl -L https://github.com/docker/buildx/releases/download/v0.3.1/buildx-v0.3.1.linux-amd64 > ~/.docker/cli-plugins/docker-buildx \
 && chmod a+x ~/.docker/cli-plugins/docker-buildx

ADD entrypoint.sh /entrypoint.sh

ENV DOCKER_CLI_EXPERIMENTAL=enabled
ENTRYPOINT [ "/entrypoint.sh" ] 
