# mqcontrol

![Docker build](https://github.com/albertnis/mqcontrol/workflows/Docker%20build/badge.svg)

## Configure It

Configuration is via environment variables. See the [`.env`](/.env) file for an example. You'll need to provide values for `MQTT_COMMAND` and `MQTT_TOPIC` before running.

### Environment Variables Reference

Name | Description | Example | Default
--- | --- | --- | ---
`MQTT_COMMAND` | Command to run when any message received on topic | `systemctl hibernate` | (required)
`MQTT_TOPIC` | Topic to listen to | `pc/laptop/hibernate` | (required)
`MQTT_BROKER` | URL and port of MQTT broker | `test.mosquitto.org:1883` | `127.0.0.1:1883`
`MQTT_CLIENTID` | Client ID for MQTT connection | `mq-control-desktop` | `mq-control`
`MQTT_USER` | Username for MQTT connection | `user` | None
`MQTT_PASSWORD` | Password for MQTT connection | `password` | None

## Run It

With Go:

```bash
go run hello.go
```

With Docker:

```bash
docker build -t mq-control .
docker run -it --rm mq-control
```

With docker-compose:

```bash
docker-compose up --build
```
