package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"syscall"

	MQTT "github.com/eclipse/paho.mqtt.golang"
	"github.com/kelseyhightower/envconfig"
)

type config struct {
	Command  string `required:"true"`
	Topic    string `required:"true"`
	Broker   string `default:"127.0.0.1:1883"`
	ClientID string `default:"mq-control"`
	User     string
	Password string
}

func subscribe(client MQTT.Client, topic string, c chan []byte) {
	handler := MQTT.MessageHandler(func(client MQTT.Client, message MQTT.Message) {
		c <- message.Payload()
	})

	token := client.Subscribe(topic, 1, handler)
	token.Wait()
	if token.Error() != nil {
		log.Fatal(token.Error().Error())
	}
}

func main() {
	fmt.Println("Started")
	var stopping = make(chan os.Signal)
	signal.Notify(stopping, syscall.SIGTERM)
	signal.Notify(stopping, syscall.SIGINT)

	var conf config
	err := envconfig.Process("mqtt", &conf)
	if err != nil {
		log.Fatal(err.Error())
	}
	if conf.Command == "" {
		log.Fatal("No MQTT_COMMAND variable provided")
	}
	if conf.Topic == "" {
		log.Fatal("No MQTT_TOPIC variable provided")
	}

	opts := MQTT.NewClientOptions()
	opts.AddBroker(conf.Broker)
	opts.SetClientID(conf.ClientID)
	opts.SetUsername(conf.User)
	opts.SetPassword(conf.Password)

	client := MQTT.NewClient(opts)
	if token := client.Connect(); token.Wait() && token.Error() != nil {
		log.Fatal(token.Error().Error())
	}

	msg := make(chan []byte)
	go subscribe(client, conf.Topic, msg)

	for {
		select {
		case payload := <-msg:
			fmt.Printf("Received message: %s\n", payload)
			cmd := exec.Command("sh", "-c", "echo worked")
			cmd.Stderr = os.Stderr
			cmd.Stdout = os.Stdout
			if err := cmd.Run(); err != nil {
				log.Fatal(err.Error())
			}

		case <-stopping:
			fmt.Println("Stopping")
			client.Disconnect(250)
			fmt.Println("Stopped")
			os.Exit(0)
		}
	}
}
