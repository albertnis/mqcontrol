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
DOCKER_BUILDKIT=1 docker build -t mqcontrol .
docker run -it --rm --network=host mqcontrol -c "echo Message received"
```

With docker-compose:

```bash
DOCKER_BUILDKIT=1 docker-compose build
docker-compose run mqcontrol -c "echo Message received"
```

## Run it at startup

### On Windows using Task Scheduler

1. Open Task Scheduler and select Action -> Create Task from the menu bar.
1. On the "General" tab, select "Run whether the user is logged in or not" and check "Do not store password...".
1. On the "Triggers" tab, create a new trigger. Use "On startup" or "At log on".
1. On the "Actions" tab, create a new action pointing to your mqcontrol binary with desired arguments.
1. Configure the remaining tabs as desired then click "OK".
1. Browse to the newly created task under the "Task Scheduler Library". Right click on the task and select "Run".

### On Linux using systemd

1. Create a systemd unit file as below, customise the `ExecStart` line, then save it at `/usr/lib/systemd/system/mqcontrol.service`:

      ```service
      [Unit]
      Description=mqcontrol remote control

      [Service]
      Type=simple
      ExecStart=/home/user/go/bin/mqcontrol -c "systemctl hibernate" -h 192.168.1.110:1883

      [Install]
      WantedBy=multi-user.target
      ```

1. Start and enable the `mqcontrol` service

      ```sh
      systemctl start mqcontrol
      systemctl enable mqcontrol
      ```