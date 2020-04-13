# mqcontrol

![Docker build](https://github.com/albertnis/mqcontrol/workflows/Docker%20build/badge.svg)

## Configure It

Configuration is via command-line arguments.

```bash
go run main.go --help
```

## Run It

With Go:

```bash
go run main.go -c "echo Message received"
```

With Docker:

```bash
docker build -t mqcontrol .
docker run -it --rm --network=host mqcontrol -c "echo Message received"
```

With docker-compose:

```bash
docker-compose build
docker-compose run mqcontrol -c "echo Message received"
```
