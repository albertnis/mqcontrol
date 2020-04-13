ARG RUNTIME_IMAGE=alpine
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
ARG BIN_EXT=
ARG BIN_NAME=${BIN_BASE_NAME}_${GOOS}_${GOARCH}${BIN_EXT}
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${goarch} go build -o ./bin/${BIN_NAME} .

FROM scratch as export
COPY --from=build /project/bin/${BIN_NAME} /${BIN_NAME}

FROM $RUNTIME_IMAGE as runtime
COPY --from=build /project/bin/${BIN_NAME} /bin/mqcontrol

ENTRYPOINT ["/bin/mqcontrol"]