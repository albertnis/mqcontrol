FROM docker:20.10.23

RUN apk add --no-cache curl

RUN mkdir -p /usr/lib/docker/cli-plugins \
  && curl -L https://github.com/docker/buildx/releases/download/v0.10.4/buildx-v0.10.4.linux-amd64 > /usr/lib/docker/cli-plugins/docker-buildx \
  && chmod a+x /usr/lib/docker/cli-plugins/docker-buildx

ADD entrypoint.sh /entrypoint.sh

ENV DOCKER_CLI_EXPERIMENTAL=enabled
ENTRYPOINT [ "/entrypoint.sh" ] 
