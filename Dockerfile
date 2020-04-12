FROM golang:1.14-alpine AS build
RUN apk add --no-cache git

WORKDIR /project

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./bin/app .

FROM scratch
COPY --from=build /project/bin/app /project/bin/app

CMD ["/project/bin/app"]