ARG TARGETIMAGE=alpine
FROM --platform=$BUILDPLATFORM golang:1.14-alpine AS build
RUN apk add --no-cache git

WORKDIR /project

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

ARG TARGETOS
ARG TARGETARCH
ARG GOOPTIONS="GOOS=${TARGETOS} GOARCH=${TARGETARCH}"
RUN CGO_ENABLED=0 ${GOOPTIONS} go build -o ./bin/mqcontrol .

FROM scratch as export
COPY --from=build /project/bin/mqcontrol /mqcontrol

FROM --platform=$TARGETPLATFORM $TARGETIMAGE AS runtime
COPY --from=build /project/bin/mqcontrol /bin

ENTRYPOINT ["/bin/mqcontrol"]