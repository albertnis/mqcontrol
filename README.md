# mqcontrol

![Docker build](https://github.com/albertnis/mqcontrol/workflows/Docker%20build/badge.svg)

mqcontrol is a lightweight and cross-platform program which subscribes to an MQTT topic and executes a predefined command whenever a message appears. It's an easy way to make your PC part of your home automation or IoT system!

## Installation

See the [releases](https://github.com/albertnis/mqcontrol/releases) page for links to binaries for your operating system and architecture. Or download the code and [run it](#run-it).

## Usage

Configuration is via command-line arguments.

```bash
mqcontrol --help
  -c string
        Command to run when any message received on topic
  -h string
        Address and port of MQTT broker (default "127.0.0.1:1883")
  -i string
        ID to use for this client (default "mqcontrol")
  -t string
        Topic to subscribe to (default "computer/command")
  -u string
        Username for MQTT connection
  -P string
        Password for MQTT connection
```

### Notes

- The command argument does not include any shell processing. If you're having problems getting commands to run or want them to run in a shell, specify the shell explicitly. For example:

    ```bash
    mqcontrol -c "/bin/sh -c \"echo message received\"" -t desktop/command/hibernate
    ```

- An error in the executed command will cause the entire program to terminate. Stderr and an exit code from the executed command will be available.

### Examples

* Make a topic to hibernate your PC

    ```bash
    mqcontrol -c "systemctl hibernate" -t desktop/command/hibernate
    ```

* Dim laptop screen when the lights are turned off

    ```bash
    mqcontrol -c "brightnessctl 50%-" -t lights/bedroom/turnoff
    ```

* Close gzdoom when the office door is opened

    ```bash
    mqcontrol -c "killall gzdoom" -t work/office/door/open
    ```

## Run It

Get then run with Go:

```bash
go get github.com/albertnis/mqcontrol
go run github.com/albertnis/mqcontrol -c "echo Message received"
```

Run with Go in cloned repo:

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
