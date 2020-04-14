FROM docker:19.03.8

RUN apk add --no-cache curl

ENV DOCKER_BUILDKIT=1
ENV DOCKER_CLI_EXPERIMENTAL=enabled
RUN docker build --platform=local -o . git://github.com/docker/buildx \
&& mkdir -p ~/.docker/cli-plugins \
&& mv buildx ~/.docker/cli-plugins/docker-buildx

RUN docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d \
 && docker buildx create --use --name builder

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ] 
