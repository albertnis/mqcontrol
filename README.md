Run it

```bash
go run hello.go
```

Run it with Docker

```bash
docker build -t mq-control .
docker run -it --rm mq-control
```

Run it with docker-compose

```bash
docker-compose up --build
```

# Environment variables reference

Name | Description | Example | default
--- | --- | --- | ---
`MQTT_COMMAND` | Command to run when any message received on topic | `systemctl hibernate` | -
`MQTT_TOPIC` | Topic to listen to | `pc/laptop/hibernate` | -
`MQTT_BROKER` | URL and port of MQTT broker | `test.mosquitto.org:1883` | `127.0.0.1:1883`
`MQTT_CLIENTID` | Client ID for MQTT connection | `mq-control-desktop` | `mq-control`
`MQTT_USER` | Username for MQTT connection | `user` | -
`MQTT_PASSWORD` | Password for MQTT connection | `password` | -