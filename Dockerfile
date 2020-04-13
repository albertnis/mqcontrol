ARG RUNTIME_IMAGE=alpine
ARG RUNTIME_PLATFORM=amd64
FROM golang:1.14-alpine AS build
RUN apk add --no-cache git

WORKDIR /project

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

ARG GOARCH=amd64
ARG GOOS=linux
ARG BIN_BASE_NAME=mqcontrol
RUN CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build -o ./bin/mqcontrol .

FROM scratch as export
COPY --from=build /project/bin/mqcontrol /mqcontrol

FROM --platform=$RUNTIME_PLATFORM $RUNTIME_IMAGE AS runtime
COPY --from=build /project/bin/mqcontrol /bin

ENTRYPOINT ["/bin/mqcontrol"]