ARG RUNTIME_IMAGE=alpine
FROM golang:1.14-alpine AS build
RUN apk add --no-cache git

WORKDIR /project

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

ARG GOARCH=amd64
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${goarch} go build -o ./bin/app .

FROM $RUNTIME_IMAGE as runtime
COPY --from=build /project/bin/app /bin/mqcontrol

ENTRYPOINT ["/bin/mqcontrol"]