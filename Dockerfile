FROM golang:1.14-alpine AS build
RUN apk add --no-cache git

WORKDIR /project
COPY . .
RUN go build -o ./bin/app .

FROM scratch
COPY --from=build /project/bin/app /project/bin/app

CMD ["/project/bin/app"]